require 'active_merchant'

class User < ActiveRecord::Base
  include ActiveMerchant::Billing
  include ActiveMerchant::Utils
  include ActionView::Helpers

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :login, :type, :updating_password
  #attr_accessible :email, :password, :password_confirmation, :name, :login, :type, :first_name, :last_name, :city_id, :zip_code
  belongs_to :subscriber
  belongs_to :city
  has_many :voucher_offers
  has_many :vouchers, :through => :voucher_offers
  has_many :user_event_types
  has_many :event_types, :through => :user_event_types
  has_many :thumbs
  
  has_many :invoices
  has_many :payment_profiles
  
  has_many :authentications
  belongs_to :promo
  
  after_create :initialize_user_event_types
  
  validates_presence_of :first_name, :email
  validates_presence_of :password, :password_confirmation, :if => :should_validate_password?
  validates_confirmation_of :password
  
  def format_balance
    number_to_currency(self.balance.to_i / 100.0)
  end
  
  def format_name
    self.first_name.to_s + " " + self.last_name.to_s
  end
  
  def birthday_datepicker
    if(self.birthday)
      self.birthday.strftime("%m/%d/%Y")
    else
      ""
    end
  end
  
  def self.parse_fb_response(signed_request)
    FbGraph::Canvas.parse_signed_request(signed_request)
  end
  
  def should_validate_password?
    updating_password || new_record?
  end
  
  def ensure_authentication_token!   
    reset_authentication_token! if authentication_token.blank?   
  end

  def apply_omniauth(omniauth)
    case omniauth['provider']
    when 'facebook'
      self.apply_facebook(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
  end
  
  def facebook?
    !self.authentications.find_by_provider('facebook').nil?
  end
  
  def twitter?
    !self.authentications.find_by_provider('twitter').nil?
  end

  def facebook
    FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end
  
  def twitter
    provider = self.authentications.find_by_provider('twitter')
    Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret)
  end
  #protected
  
  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['user_hash'] rescue false)
      self.email = (extra['email'] rescue '')
    end
  end
  
  def set_default_payment_profile(payment_profile_id)
    self.default_payment_profile_id = payment_profile_id
    self.save
  end
  
  def is_default_payment_profile?(payment_profile_id)
    self.default_payment_profile_id == payment_profile_id
  end
  
  def initialize_user_event_types
    if (!self.city_id)
      self.city_id = City.find_by_name("New York City").id
      self.save
    end
    begin
      h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')
      if Rails.env.production?
        list_id = h.find_list_id_by_name('Signups')
      else
        list_id = h.find_list_id_by_name('Development')
      end
      h.list_update_member(list_id, self.email, {'CITY' => self.city.name, 'FNAME' => self.first_name, 'LNAME' => self.last_name}, 'html', false)
    rescue
      begin
        h.list_subscribe(list_id, self.email, {'CITY' => self.city.name, 'FNAME' => self.first_name, 'LNAME' => self.last_name}, 'html', false, false, false, false)
      rescue
      end
    end
    
    i = 0
    EventType.all.each do |event_type|
      user_event_type = UserEventType.new(:user_id => self.id, :event_type_id => event_type.id, :value => i)
      user_event_type.save
      i += 1
    end
    
    #if Rails.env.production?
      self.create_cim_profile
    # end
    
    subscriber = Subscriber.find_or_create_by_email(self.email)
    self.subscriber_id = subscriber.id
    self.save
    
    self.referral_code = rand(36**8).to_s(36)
    self.save
  end
  
 def self.find_for_database_authentication(warden_conditions)
   conditions = warden_conditions.dup
   login = conditions.delete(:login)
   where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
 end
 
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      user = User.new(:email => data["email"], :password => Devise.friendly_token[0,20])
      user.save(false)
      user
    end
  end 
  
  def self.find_for_google_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20]) 
    end
  end 

  #private
  def create_cim_profile
    #Login to the gateway using your credentials in environment.rb
    @gateway = get_payment_gateway

    #setup the user object to save
    @user = {:profile => user_profile}

    #send the create message to the gateway API
    response = @gateway.create_customer_profile(@user)

    if response.success? and response.authorization
      self.customer_cim_id = response.authorization
      self.save
      return true
    end
    puts response.message
    return false
  end

  def update_cim_profile
    if not self.customer_cim_id
      return false
    end
    @gateway = get_payment_gateway

    response = @gateway.update_customer_profile(:profile => user_profile.merge({
        :customer_profile_id => self.customer_cim_id
      }))

    if response.success?
      return true
    end
    return false
  end

  def delete_cim_profile
    if not self.customer_cim_id
      return false
    end
    @gateway = get_payment_gateway

    response = @gateway.delete_customer_profile(:customer_profile_id => self.customer_cim_id)

    if response.success?
      return true
    end
    return false
  end

  def user_profile
    return {:merchant_customer_id => self.id, :email => self.email, :description => self.name}
  end


end
