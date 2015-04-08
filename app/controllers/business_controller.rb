class BusinessController < ApplicationController
  before_filter :authenticate_business!, :except => [:login, :signup, :landing]
  
  def save_and_add_location
    current_business.venues.first.update_params(params[:venue])
    redirect_to location_edit_path
  end
  
  def save_location
    if (params[:venue][:id] && Venue.exists?(params[:venue][:id]))
      @location = Venue.find(params[:venue][:id])
      @location.update_attributes(params[:venue])
    else
      venue = Venue.new(params[:venue])
      venue.business_id = current_business.id
      venue.active = true
      venue.save
    end
    if (!params[:commit])
      flash[:notice] = "Venue location saved."
      redirect_to location_edit_path
    else
      flash[:notice] = "Venue location saved."
      redirect_to '/business/account#myvenue'
    end
  end
  
  def edit_location
    if (params[:id])
      @location = Venue.find(params[:id])
    else
      @location = Venue.new
    end
  end
  
  def delete_location
    venue = Venue.find(params[:id])
    venue.active = false
    venue.save
    flash[:notice] = "Venue location successfully removed."
    redirect_to '/business/account#myvenue'
  end
  
  def delete_payment_profile
    if PaymentType.find(params[:payment_type_id]).name == "Direct Deposit"
      DirectDepositProfile.find(params[:payment_profile_id]).delete
    elsif PaymentType.find(params[:payment_type_id]).name == "Paper Check via USPS"
      PaperCheckProfile.find(params[:payment_profile_id]).delete      
    elsif PaymentType.find(params[:payment_type_id]).name == "Paypal"
      PaypalProfile.find(params[:payment_profile_id]).delete
    end
    
    flash[:notice] = "Payment profile has been deleted."
    redirect_to '/business/account#mypayment'  
  end
  
  def set_default_payment
    current_business.default_payment_type_id = params[:payment_type_id]
    current_business.default_payment_profile_id = params[:payment_profile_id]
    current_business.save
    
    flash[:notice] = "Default payment settings have been updated."
    redirect_to '/business/account#mypayment'
  end
  
  def change_password
    if (current_business.valid_password?(params[:business_password][:current_password]))
      current_business.password = params[:business_password][:password]
      current_business.password_confirmation = params[:business_password][:password_confirmation]
      current_business.save(false)
      sign_in(current_business, :bypass => true)
      flash[:notice] = "Password changed successfully."
      redirect_to '/business/account'
    else
      flash[:error_explanation] = "The current password you provided is incorrect."
      redirect_to '/business/account#change-password'
    end
  end
  
  def login
    @title = "Business Login | UsherBuddy, Yield-Management for Events"
  end
  
  def signup
    @title = "Business Signup | UsherBuddy, Yield-Management for Events"
    @business = Business.new
  end
  
  def landing
    if (current_business)
      if (flash[:notice] && !flash[:notice].empty?)
        flash[:notice] = flash[:notice]
      end
      redirect_to business_account_path
    end
    @title = "Yield Management Solution for Events | UsherBuddy"
  end
  
  def account
    if (business_signed_in?)
      cookies.permanent[:business_id] = current_business.id
    end
    @title = "Manage Venue Account | UsherBuddy, Yield-Management for Events"
    @business = current_business
    @business.updating_password = true
    @event_types = EventType.all
    @amenities = Amenity.all
    
    @location_list = @business.venues.find_all_by_active(true)
    if (@location_list.size > 0)
      @first_location = @location_list.first
    else
      @first_location = Venue.new
    end
    
    if Rails.env.production?
      @upcoming_event_templates = @business.event_templates.where("(to_date >= ? OR to_date IS NULL) AND active = '1'", Time.now)
      @past_event_templates = @business.event_templates.where("to_date < ? AND active = '1'", Time.now)
      @upcoming_all_events = @business.vouchers.where("event_time >= ? AND active = '1'", Time.now).order("event_time ASC")
      @past_all_events = @business.vouchers.where("event_time < ? AND active = '1'", Time.now)
    
      #These are for events with deals launched...
      @upcoming_launched_events = @business.vouchers.where("event_time >= ? AND launched = '1' AND active = '1'", Time.now).order("event_time ASC")
      @past_launched_events = @business.vouchers.where("event_time < ? AND launched = '1' AND active = '1'", Time.now)
    else
      @upcoming_event_templates = @business.event_templates.where("(to_date >= ? OR to_date IS NULL) AND active = 't'", Time.now)
      @past_event_templates = @business.event_templates.where("to_date < ? AND active = 't'", Time.now)
      @upcoming_all_events = @business.vouchers.where("event_time >= ? AND active = 't'", Time.now).order("event_time ASC")
      @past_all_events = @business.vouchers.where("event_time < ? AND active = 't'", Time.now)
    
      #These are for events with deals launched...
      @upcoming_launched_events = @business.vouchers.where("event_time >= ? AND launched = 't' AND active = 't'", Time.now).order("event_time ASC")
      @past_launched_events = @business.vouchers.where("event_time < ? AND launched = 't' AND active = 't'", Time.now)
    end
    
    @paypal_profiles = PaypalProfile.find_all_by_business_id(current_business.id)
    @direct_deposit_profiles = DirectDepositProfile.find_all_by_business_id(current_business.id)
    @paper_check_profiles = PaperCheckProfile.find_all_by_business_id(current_business.id)
    
    @paypal_type_id = PaymentType.find_by_name("Paypal")
    @direct_deposit_type_id = PaymentType.find_by_name("Direct Deposit")
    @paper_check_type_id = PaymentType.find_by_name("Paper Check via USPS")
    
    #if (@business.paypal_profile)
    #  @paypal_profile = @business.paypal_profile
    #else
      @paypal_profile = PaypalProfile.new
    #end
    
    #if (@business.paper_check_profile)
    #  @paper_check_profile = @business.paper_check_profile
    #else
      @paper_check_profile = PaperCheckProfile.new
    #end
    #
    #if (@business.direct_deposit_profile)
    #  @direct_deposit_profile = @business.direct_deposit_profile
    #else
      @direct_deposit_profile = DirectDepositProfile.new
    #end
    
  end
  
  def update
    @business = current_business
    #@business.event_types << EventType.find(params[:business_event_types]) unless params[:event_types].nil?
    #@business.amenities << Amenity.find(params[:business_amenities]) unless params[:amenities].nil?
    if (params[:business])
      @business.attributes = params[:business]
      @business.save(false)
      
      begin
        h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')
        if Rails.env.production?
          list_id = h.find_list_id_by_name('Businesses')
        else
          list_id = h.find_list_id_by_name('Development Business')
        end
        if (@business.city_id)
          city_name = @business.city.name
        else
          city_name = @business.city_address.to_s
        end
        h.list_update_member(list_id, @business.email, {'CITY' => city_name, 'FNAME' => @business.first_name, 'LNAME' => @business.last_name, 'VENUE' => @business.name}, 'html', false)
      rescue
      end
      
    elsif (params[:venue])
      @venue = @business.venues.first
      @venue.update_attributes(params[:venue])
      if (!params[:commit])
        flash[:notice] = "Venue location information saved."
        redirect_to location_edit_path
        return
      end
    end
    
    if (params[:business_event_types])
      EventType.all.each do |event_type|
        if (@business.business_event_types.exists?(:event_type_id => event_type.id) && params[:business_event_types].index(event_type.id.to_s).nil?)
          @business.business_event_types.find_by_event_type_id(event_type.id).delete
        elsif (!@business.business_event_types.exists?(:event_type_id => event_type.id) && !params[:business_event_types].index(event_type.id.to_s).nil?)
          BusinessEventType.new(:business_id => @business.id, :event_type_id => event_type.id).save
        end
      end
    else
      @business.business_event_types.delete_all
    end
    
    if (params[:business_amenities])
      Amenity.all.each do |amenity|
        if (@business.business_amenities.exists?(:amenity_id => amenity.id) && params[:business_amenities].index(amenity.id.to_s).nil?)
          @business.business_amenities.find_by_amenity_id(amenity.id).delete
        elsif (!@business.business_amenities.exists?(:amenity_id => amenity.id) && !params[:business_amenities].index(amenity.id.to_s).nil?)
          BusinessAmenity.new(:business_id => @business.id, :amenity_id => amenity.id).save
        end
      end
    else
      @business.business_amenities.delete_all
    end

    flash[:notice] = "Account has been updated."
    redirect_to (business_account_path)
  end
  
  def populate_paypal_profile
    @paypal_profile = PaypalProfile.find(params[:id])
  end
  
  def populate_direct_deposit_profile
    @direct_deposit_profile = DirectDepositProfile.find(params[:id])
  end
  
  def populate_paper_check_profile
    @paper_check_profile = PaperCheckProfile.find(params[:id])
  end
  
  def update_paypal_profile
    if (PaypalProfile.exists?(params[:paypal_profile][:id]))
      profile = PaypalProfile.find(params[:paypal_profile][:id])
      profile.update_attributes(params[:paypal_profile])
    else
      profile = PaypalProfile.new(params[:paypal_profile])
      profile.business_id = current_business.id
      profile.save
    end
    
    current_business.payment_type_id = PaymentType.find_by_name("Paypal").id
    current_business.save
    
    flash[:notice] = "Paypal payment information has been updated."
    redirect_to '/business/account#mypayment'
  end
  
  def update_direct_deposit_profile
    if (DirectDepositProfile.exists?(params[:direct_deposit_profile][:id]))
      profile = DirectDepositProfile.find(params[:direct_deposit_profile][:id])
      profile.update_attributes(params[:direct_deposit_profile])
    else
      profile = DirectDepositProfile.new(params[:direct_deposit_profile])
      profile.business_id = current_business.id
      profile.save
    end
    
    current_business.payment_type_id = PaymentType.find_by_name("Direct Deposit").id
    current_business.save
    
    flash[:notice] = "Direct deposit payment information has been updated."
    redirect_to '/business/account#mypayment'
  end
  
  def update_paper_check_profile
    if (PaperCheckProfile.exists?(params[:paper_check_profile][:id]))
      profile = PaperCheckProfile.find(params[:paper_check_profile][:id])
      profile.update_attributes(params[:paper_check_profile])
    else
      profile = PaperCheckProfile.new(params[:paper_check_profile])
      profile.business_id = current_business.id
      profile.save
    end
    
    current_business.payment_type_id = PaymentType.find_by_name("Paper Check via USPS").id
    current_business.save
    
    flash[:notice] = "Paper check payment information has been updated."
    redirect_to '/business/account#mypayment'
  end

end
