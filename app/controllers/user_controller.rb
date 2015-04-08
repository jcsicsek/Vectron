include ActiveMerchant::Billing
include ActiveMerchant::Utils
#include FbGraph::Canvas

class UserController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:account, :create_payment_profile]
  
#  if Rails.env == 'production'
#    ssl_required :change_password, :update, :account, :set_default_payment, :create_payment_profile, :signup, :login
#  end 

  def quick_signin
    user = User.find_by_email(params[:user][:login])
    if (!user)
      flash[:error_explanation] = "The email address you have entered is invalid."
      redirect_to :back
    elsif (!user.valid_password?(params[:user][:password]))
      flash[:error_explanation] = "The password you have entered is invalid."
      redirect_to :back
    else
      sign_in(user, :bypass => true)
      flash[:notice] = "Signed in successfully."
      redirect_to :back
    end
  end
  
  def facebook_registration
    request_info = SignedRequestParser.parse(params[:signed_request], '67f4333ef08bd2bff04e45d9e1efff50')
    info = request_info["registration"]
    #puts info
    name_array = info["name"].split(" ")
    first_name = name_array.first
    last_name = name_array.last
    email = info["email"]
    password = info["password"]
    
    if (User.exists?(:email => email))
      flash[:error_explanation] = "A user already exists with the email address associated with this Facebook account!"
      redirect_to users_new_path
    else
      #TODO:  Get this from the Facebook location
      city_id = City.find_by_name("New York City").id
      user = User.new(:email => email, :first_name => first_name, :last_name => last_name, :password => password, :password_confirmation => password, :city_id => city_id)
      user.save(false)
      sign_in(user, :bypass => true)
      flash[:notice] = "Welcome to UsherBuddy!  You can now log in to this site using the email address associated with your Facebook account, and the password you provided."
      redirect_to home_path
    end
  end
  
  def change_password
    if (current_user.valid_password?(params[:user][:current_password]))
      current_user.password = params[:user][:password]
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.save(false)
      sign_in(current_user, :bypass => true)
      flash[:notice] = "Password changed successfully."
      redirect_to '/account'
    else
      flash[:error_explanation] = "The current password you provided is incorrect."
      redirect_to '/account#myaccount'
    end
  end
  
  def update
    @user = current_user
    if (params[:user])
      @user.attributes = params[:user]
      if (Chronic.parse(params[:user][:birthday]))
        @user.birthday = Chronic.parse(params[:user][:birthday])
      end
      @user.save(false)
    elsif (params[:user_info])
      @user.attributes = params[:user_info]
      @user.save(false)
    end
    
    begin
      h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')
      if Rails.env.production?
        list_id = h.find_list_id_by_name('Signups')
      else
        list_id = h.find_list_id_by_name('Development')
      end
      h.list_update_member(list_id, @user.email, {'CITY' => @user.city.name, 'FNAME' => @user.first_name, 'LNAME' => @user.last_name}, 'html', false)
    rescue
    end
    
    #@user.update_attributes(form_data)
    flash[:notice] = "Profile information saved."
    redirect_to '/account#myaccount'
  end
  
  def home
    if (user_signed_in?)
      cookies.permanent[:user_id] = current_user.id
      @initial_thumbs = current_user.thumbs
      
    end
    if (current_user && current_user.event_types.count > 0)
      @user_event_types = UserEventType.where(:user_id => current_user.id).order("value ASC")
    else
      @user_event_types = []
      i = 0
      EventType.all.each do |event_type|
        @user_event_types << UserEventType.new(:event_type_id => event_type.id, :value => i)
        i += 1
      end
    end
    
    @title = "UsherBuddy, Last-Minute Event Tickets"
  end
  
  def landing
    @new_user = User.new
    @title = "UsherBuddy, Last-Minute Event Tickets"
  end
  
  def account
    @user = current_user
    @user.birthday = @user.birthday_datepicker
    @user.updating_password = true
    #@user = User.new
    #@user2 = User.new
    @active_voucher_offers = @user.voucher_offers.joins(:voucher).where("event_time >= ?", Time.now)
    @past_voucher_offers = @user.voucher_offers.joins(:voucher).where("event_time < ?", Time.now)
    #@all_voucher_offers = @past_voucher_offers + @active_voucher_offers
    @title = "Your Account | UsherBuddy, Last-Minute Event Tickets"
    @credit_card = CreditCardForm.new
    if (@user.balance.to_i > 0)
      @balance_info = "You have " + @user.format_balance + " in UsherBuddy credit!"
    else
      @balance_info = ""
    end
  end
  
  def set_default_payment
    current_user.set_default_payment_profile(params[:payment_profile_id])
    
    flash[:notice] = "Default payment settings have been updated."
    redirect_to "/account#myaccount"
  end
  
  def delete_payment_profile
    payment_profile = PaymentProfile.find(params[:payment_profile_id])
    success = payment_profile.destroy
    if (success)
      flash[:notice] = "Payment method deleted successfully."
    else
      flash[:error_explanation] = "There was a problem deleting this payment method.  Please contact UsherBuddy support if you experience further issues."
    end
    
    redirect_to "/account#myaccount"
  end
  
  def create_payment_profile
    month = params[:credit_card_form][:expiry_month].to_i.to_s
    
    credit_card = {
      :number => params[:credit_card_form][:card_number],
      :verification_value => params[:credit_card_form][:security_code],
      :month => month,
      :year => params[:credit_card_form][:expiry_year],
      :first_name => params[:credit_card_form][:first_name],
      :last_name => params[:credit_card_form][:last_name],
      :type => params[:credit_card_form][:card_type]
    }
    
    address = {
      :name => params[:credit_card_form][:first_name] + " " + params[:credit_card_form][:last_name].to_s,
      :address1 => "",
      :city => "",
      :state => "",
      :phone => "",
      #:address1 => params[:credit_card_form][:address],
      #:city => params[:credit_card_form][:city],
      #:state => params[:credit_card_form][:state],
      #:phone => params[:credit_card_form][:phone],
      :zip => params[:credit_card_form][:zip]
    }
    
    user_id = current_user.id
    before_payment_count = PaymentProfile.find_all_by_user_id(user_id).count
    PaymentProfile.create(:address => address, :user_id => user_id, :credit_card => credit_card)
    after_payment_count = PaymentProfile.find_all_by_user_id(user_id).count
    if after_payment_count > before_payment_count
      flash[:notice] = "Thanks!  Your payment information has been saved!"
    else
      flash[:error_explanation] = "There was a problem with the credit card you provided.  Please double-check and try again."
    end
    redirect_to "/account#myaccount"
  end
  
  def signup
    @title = "Signup | UsherBuddy, Last-Minute Event Tickets"
    @user = User.new
    @user.updating_password = true
  end
  
  def login
    @title = "Login | UsherBuddy, Last-Minute Event Tickets"
  end
end