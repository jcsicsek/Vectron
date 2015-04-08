class Business < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :login, :updating_password, :photo_url
  
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :first_name, :last_name, :description, :street_address, :street_address_2, :city_address, :city_id, :state, :zip_code, :phone_number, :neighborhood, :website_url, :twitter_handle, :facebook_url, :photo
  has_many :vouchers
  has_many :event_templates
  has_many :venues
  
  has_many :business_event_types
  has_many :event_types, :through => :business_event_types
  
  has_many :business_amenities
  has_many :amenities, :through => :business_amenities
  
  has_one :direct_deposit_profile
  has_one :paper_check_profile
  has_one :paypal_profile
  
  belongs_to :payment_type
  
  has_attached_file :photo,
  :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_protocol => "https",
    :path => "business/:attachment/:id/:style.:extension",
    :bucket => Rails.env.production? ? 'images.usherbuddy.com' : 'images.dev.usherbuddy.com'
  
  after_create :add_to_mailchimp
  
  validates_presence_of :name, :first_name, :last_name, :street_address, :email, :city_address, :neighborhood, :state, :zip_code, :phone_number
  validates_confirmation_of :password
  
  #validates_presence_of :password, :password_confirmation, :current_password, :if => :should_validate_password?
  
  def short_description
    self.description.to_s[0..150]
  end
  
  def add_to_mailchimp
    begin
      h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')

      if Rails.env.production?
        list_id = h.find_list_id_by_name('Businesses')
      else
        list_id = h.find_list_id_by_name('Development Business')
      end
      if (self.city_id)
        city_name = self.city.name
      else
        city_name = self.city_address.to_s
      end
      h.list_subscribe(list_id, self.email, {'FNAME' => self.first_name, 'LNAME' => self.last_name, 'CITY' => city_name, 'VENUE' => self.name}, 'html', false, false, false, false)
    rescue
    end
    
    #TODO:  This code should go once these fields are permanently removed from the Business model!
    venue = Venue.new
    venue.name = self.name
    venue.street_address = self.street_address
    venue.street_address_2 = self.street_address_2
    venue.city_address = self.city_address
    venue.state = self.state
    venue.zip_code = self.zip_code
    venue.phone_number = self.phone_number
    venue.neighborhood = self.neighborhood
    venue.business_id = self.id
    venue.active = true
    venue.save
    
    #set default ticket cutoff to 30 minutes before show
    self.ticket_cutoff = 30
    self.save
  end
  
  def get_photo_url
    if (self.new_record?)
      ""
    elsif (self.photo_file_name && !self.photo_file_name.empty?)
      self.photo.url
    elsif (self.photo_remote_url && !self.photo_remote_url.empty?)
      self.photo_remote_url.to_s
    else
      ""
    end
  end
  
  def format_last_login
    if (self.last_sign_in_at)
      self.last_sign_in_at.strftime("%A, %B %d, %Y at %I:%M %p")
    else
      "Never"
    end
  end
  
  def contact_info
    self.first_name.to_s + " " + self.last_name.to_s + ", " + self.phone_number.to_s + ", " + self.email.to_s
  end
  
  def city_state_zip
    self.city_address.to_s + ", " + self.state.to_s + " " + self.zip_code.to_s
  end
  
  def should_validate_password?
    updating_password || new_record?
  end
  
  def self.create_skeleton(business_name)
    email = business_name.gsub(/ /,'') + "@email.com"
    password = "password"
    description = "Automatically generated"
    neighborhood = "NYC"
    city_id = City.find_by_name("New York City").id
    bus = Business.new(:name => business_name, :email => email, :password => password, :password_confirmation => password, :description => description, :neighborhood => neighborhood, :city_id => city_id)
    bus.save(false)
    return bus.id
  end
  
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  end
end
