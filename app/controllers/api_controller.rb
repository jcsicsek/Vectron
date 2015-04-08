class ApiController < ApplicationController
  def events_by_xml
    #render :json => Voucher.all
    event_type = EventType.find_by_name(params[:eventType])
    vouchers = Voucher.find_all_by_event_type_id(event_type.id)
    render :xml => vouchers, :include => :business
  end
  def events_by_json
    #content_type :json
    event_type = EventType.find_by_name(params[:eventType])
    vouchers = Voucher.find_all_by_event_type_id(event_type.id)
    #JSON.pretty_generate(vouchers)
    render :json => vouchers, :callback => params[:callback]
  end
  
  def all_events
    event_types = {:event_types => EventType.find_all_by_active(true)}
    render :json => event_types, :include => :vouchers, :callback => params[:callback]
  end
  
  def events
    rv = Array.new
    event_type_id = EventType.find_by_name(params[:eventType]).id
    vouchers = Voucher.find_all_by_active_and_launched_and_event_type_id(true, true, event_type_id)
    vouchers.each do |vouch|
      rv << vouch.api_hash
    end
    render :json => rv
  end
  
  def sencha_events
    event_types = EventType.find_all_by_active(true)
    event_type_array = Array.new
    event_types.each do |event_type|
      vouchers_array = Array.new
      vouchers = event_type.vouchers.find_all_by_active_and_launched(true, true)
      vouchers.each do |voucher|
        vouchers_array << voucher.api_hash
      end
      event_type_hash = {:text => event_type.name, :model => "EventType", :info => "", :leaf => false, :items => vouchers_array}
      event_type_array << event_type_hash
    end
    root_hash = {:items => event_type_array}
    
    render :json => root_hash
  end
  
  def sencha_cities
    cities = City.find_all_by_active(true)
    cities_array = Array.new
    cities.each do |city|
      cities_array << {:text => city.name, :model => "City", :info => "", :leaf => true, :items => Array.new}
    end
    root_hash = {:items => cities_array}
    
    render :json => root_hash
  end
  
  def sencha_purchases
    user_id = User.find_by_email(params[:user]).id
    purchases = VoucherOffer.find_all_by_user_id(user_id)
    purchases_array = Array.new
    purchases.each do |purchase|
      purchases_array << {:text => purchase.voucher.format_title, :model => "Purchase", :info => purchase.voucher.description, :date_purchased => purchase.voucher.format_event_date, :voucher_code => purchase.ticket_id, :leaf => true, :items => Array.new}
    end
    root_hash = {:items => purchases_array}
    
    render :json => root_hash
  end
  
  def sencha_settings
    user = User.find_by_email(params[:user])
    city = user.city.name
    users_array = Array.new
    users_array << {:text => user.email, :model => "User", :info => "", :leaf => true, :first_name => user.first_name, :last_name => user.last_name, :city => city, :items => Array.new}
    root_hash = {:items => users_array}
    
    render :json => root_hash
  end
  
  def sencha_payments
    user = User.find_by_email(params[:user])
    payment_profiles = user.payment_profiles
    profiles_array = Array.new
    payment_profiles.each do |profile|
      profiles_array << {:text => profile.get_cc_number, :model => "PaymentProfile", :info => "", :leaf => true, :items => Array.new}
    end
    root_hash = {:items => profiles_array}
    
    render :json => root_hash
  end
  
  def check_token
    if user_signed_in?
      rv = current_user.email
    else
      rv = "No session!"
    end
    
    render :json => rv
  end
  
  def get_token
    email = params[:email]
    password = params[:password]
    user = User.find_by_email(email)
    if (!user)
      status = "User does not exist."
      token = "Invalid"
    elsif (!user.valid_password?(password))
      status = "Invalid password."
      token = "Invalid"
    else
      status = "Success."
      user.ensure_authentication_token!
      token = user.authentication_token
    end
    
    rv = {:status => status, :token => token}
    render :json => rv
  end
      
end
