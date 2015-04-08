class VouchersController < ApplicationController
  
  include ActiveMerchant::Billing
  include ActiveMerchant::Utils
  
  before_filter :store_location, :only => [:checkout]
  before_filter :authenticate_user!, :only => [:signin_and_checkout]
  before_filter :authenticate_business!, :only => [:update, :business_event_modify, :deal_status]
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  
  def signin_and_checkout
    redirect_to session[:return_to]
  end
  
  def swap_individual_deal
    @voucher = Voucher.find(params[:voucher_id])
    if (user_signed_in?)
      @thumb = Thumb.find_by_user_id_and_voucher_id(current_user.id, @voucher.id)
    end
    @other_events = Voucher.where("business_id = ? AND active = ? AND launched = ? AND event_time >= ?", @voucher.business_id, true, true, Time.now).order("event_time ASC")
  end
  
  def swap_featured
    @voucher = Voucher.find(params[:voucher_id])
    @current_voucher_id = params[:current_voucher_id]
    if (user_signed_in?)
      @initial_thumbs = current_user.thumbs
    end
  end
  
  def thumbs_up
    @voucher = Voucher.find(params[:voucher_id])
    if (user_signed_in?)
      @user_id = current_user.id
      thumb = Thumb.find_or_create_by_user_id_and_voucher_id(@user_id, @voucher.id)
      thumb.up = true
      thumb.down = false
      thumb.save
    end
  end
  
  def thumbs_down
    @voucher = Voucher.find(params[:voucher_id])
    if (user_signed_in?)
      @user_id = current_user.id
      thumb = Thumb.find_or_create_by_user_id_and_voucher_id(@user_id, @voucher.id)
      thumb.up = false
      thumb.down = true
      thumb.save
    end
  end
  
  def delete
    voucher = Voucher.find(params[:id])
    voucher.active = false
    voucher.save
    flash[:notice] = 'Event deleted.'
    redirect_to(business_account_path + "#myevents")
  end
  
  def delete_template
    template = EventTemplate.find(params[:id])
    template.active = false
    template.save
    flash[:notice] = 'Event template deleted.'
    redirect_to(business_account_path + "#myevents")
  end
  
  def deal_status
    @voucher = Voucher.find(params[:id])
    if (current_business.id != @voucher.business_id)
      redirect_to business_login_path
    end
    @title = "Manage Event for " + @voucher.name + " | UsherBuddy, Yield-Management for Events"
  end
  
  def update
    if (params[:voucher])
      if (!Voucher.exists?(params[:voucher][:id]))
        voucher = Voucher.new(params[:voucher])
        #if (Chronic.parse(params[:voucher][:time_only] + " " + params[:voucher][:date_only]))
          voucher.event_time = Chronic.parse(params[:voucher][:date_only] + " " + params[:voucher][:time_only])
        #end
        voucher.business_id = current_business.id
        voucher.active = true
        voucher.commission = 0.35
        voucher.purchase_count = 0
        voucher.voucher_price_cents = params[:voucher][:voucher_price_cents].gsub(".", "").gsub("$", "")
        voucher.full_value_cents = params[:voucher][:full_value_cents].gsub(".", "").gsub("$", "")
        voucher.save
      else
        voucher = Voucher.find(params[:voucher][:id])
        voucher.update_attributes(params[:voucher])
        #if (Chronic.parse(params[:voucher][:time_only] + " " + params[:voucher][:date_only]))
          voucher.event_time = Chronic.parse(params[:voucher][:date_only] + " " + params[:voucher][:time_only])
        #  puts "AHHHHHHHHHHHHHHHHHHH"
        #end
        #puts "NOOOOOO?"
        voucher.voucher_price_cents = params[:voucher][:voucher_price_cents].gsub(".", "").gsub("$", "")
        voucher.full_value_cents = params[:voucher][:full_value_cents].gsub(".", "").gsub("$", "")
        voucher.save
      end
    elsif (params[:event_template])
      voucher = Voucher.new(params[:event_template])
      template = EventTemplate.find(params[:event_template][:event_template_id])
      #if (Chronic.parse(params[:event_template][:time_only] + " " + params[:event_template][:date_only]))
        voucher.event_time = Chronic.parse(params[:event_template][:date_only] + " " + params[:event_template][:time_only])
      #end
      if (template)
        if (!template.photo_file_name.nil?)
          voucher.photo = template.photo
        end
        if (!template.photo_remote_url.nil?)
          voucher.photo_remote_url = template.photo_remote_url
        end
      end
      voucher.business_id = current_business.id
      voucher.active = true
      voucher.commission = 0.35
      voucher.purchase_count = 0
      voucher.voucher_price_cents = params[:event_template][:voucher_price_cents].gsub(".", "").gsub("$", "")
      voucher.full_value_cents = params[:event_template][:full_value_cents].gsub(".", "").gsub("$", "")
      voucher.save(false)
    end
      
    flash[:notice] = 'Event saved successfully'
    redirect_to(business_account_path + "#myevents")
  end
  
  def update_template
    if (!EventTemplate.exists?(params[:event_template][:id]))
      template = EventTemplate.new(params[:event_template])
      if (Chronic.parse(params[:event_template][:event_time]))
        template.event_time = Chronic.parse(params[:event_template][:event_time])
      end
      if (Chronic.parse(params[:event_template][:from_date]))
        template.from_date = Chronic.parse(params[:event_template][:from_date])
      end
      if (Chronic.parse(params[:event_template][:to_date]))
        template.to_date = Chronic.parse(params[:event_template][:to_date])
      end
      template.business_id = current_business.id
      template.active = true
      template.full_value_cents = params[:event_template][:full_value_cents].gsub(".", "").gsub("$", "")
      template.save
    else
      template = EventTemplate.find(params[:event_template][:id])
      template.update_attributes(params[:event_template])
      if (Chronic.parse(params[:event_template][:event_time]))
        template.event_time = Chronic.parse(params[:event_template][:event_time])
      end
      if (Chronic.parse(params[:event_template][:from_date]))
        template.from_date = Chronic.parse(params[:event_template][:from_date])
      end
      if (Chronic.parse(params[:event_template][:to_date]))
        template.to_date = Chronic.parse(params[:event_template][:to_date])
      end
      template.full_value_cents = params[:event_template][:full_value_cents].gsub(".", "").gsub("$", "")
      template.save
    end
    flash[:notice] = 'Recurring event saved successfully'
    redirect_to(business_account_path + "#myevents")
  end
  
  def show
    if (user_signed_in?)
      @initial_thumbs = current_user.thumbs.find_by_voucher_id(params[:id])
    end
    if (params[:share])
      cookies[:referral_code] = params[:share]
    end
    @event = Voucher.find(params[:id])
    @city_state_zip = @event.venue.city_address.to_s + ", " + @event.venue.state.to_s + " " + @event.venue.zip_code.to_s
    @street_address = @event.venue.street_address.to_s
    @gmaps_address = @street_address + " " + @city_state_zip
    @title = @event.format_title + " | UsherBuddy, Last-Minute Event Tickets" 
    @other_events = Voucher.where("business_id = ? AND active = ? AND launched = ? AND event_time >= ?", @event.business_id, true, true, Time.now).order("event_time ASC")
  end
  
  def share_on_facebook
    if (current_user.facebook?)
      voucher = Voucher.find(params[:id])
      message = voucher.format_blurb + " on UsherBuddy!"
      current_user.facebook.feed!(
        :message => message, 
        :name => "UsherBuddy Event"
      )
      redirect_to home_path
    else
      redirect_to user_omniauth_authorize_path(:facebook)
    end
  end
  
  def share_on_twitter
    if (current_user.twitter?)
      voucher = Voucher.find(params[:id])
      message = voucher.format_blurb + " on UsherBuddy!"
      current_user.twitter.update(message)
      redirect_to home_path
    else
      redirect_to user_omniauth_authorize_path(:twitter)
    end
  end
  
  def event_template_modify
    @locations = current_business.venues.find_all_by_active(true)
    if (params[:id] == 'new')
      @event_template = EventTemplate.new
      @title = "Add Recurring Event | UsherBuddy, Yield-Management for Events"
      @event_template.venue_id = @locations.first.id
      @event_template.ticket_cutoff = current_business.ticket_cutoff.to_i
    else
      @event_template = EventTemplate.find(params[:id])
      @event_template.full_value_cents = @event_template.format_normal_price
      @event_template.event_time = @event_template.timepicker_time_only
      @event_template.from_date = @event_template.datepicker_from
      @event_template.to_date = @event_template.datepicker_to

      @title = "Edit Recurring Event - " + @event_template.name + " | UsherBuddy, Yield-Management for Events"
    end
  end
  
  def business_event_modify
    @locations = current_business.venues.find_all_by_active(true)
    if (params[:id] == 'new')
      if (params[:event_template_id])
        @voucher = EventTemplate.find(params[:event_template_id])
        @voucher.full_value_cents = @voucher.format_normal_price
        @voucher.time_only = @voucher.timepicker_time_only
        @voucher.date_only = ""
        @voucher.launched = true
      else
        @voucher = Voucher.new
        @voucher.venue_id = @locations.first.id
        @voucher.ticket_cutoff = current_business.ticket_cutoff.to_i
      end
      @title = "Add New Event | UsherBuddy, Yield-Management for Events"
    else
      @voucher = Voucher.find(params[:id])
      @voucher.voucher_price_cents = @voucher.format_discount_price
      @voucher.full_value_cents = @voucher.format_normal_price
      @voucher.time_only = @voucher.timepicker_time_only
      @voucher.date_only = @voucher.datepicker_date_only
      @title = "Edit - " + @voucher.name + "UsherBuddy"
    end
  end
  
  def checkout
    #merchant_id = "326998975699405"
    #merchant_key = "xUmwz7EJP3oD1gaXqL_GBA"
    
    #@cart = GoogleCheckout::Cart.new(merchant_id, merchant_key)
    #@cart.add_item(:name => 'Chair', :description => 'A sturdy, wooden chair',
    #                :price => 44.99)
    if (user_signed_in?)
      @user = current_user
    else
      @user = User.new
    end
    if (@user.payment_profiles.count > 0 && @user.default_payment_profile_id.nil?)
      @user.default_payment_profile_id = @user.payment_profiles.first.id
      @user.save(false)
    end
    @cart = Cart.new
    @cart.order_amount = 1
    @new_credit_card = CreditCardForm.new
    @voucher = Voucher.find(params[:id])
    @payment_profiles = @user.payment_profiles
    @account_balance = @user.balance.to_i
  end
  
  
  def paypal_callback
    token = params[:token]
    payer_id = params[:PayerID]
    get_paypal_express_gateway.purchase(flash[:paypal_purchase_amount], {:ip => request.remote_ip, :token => token, :payer_id => payer_id})
    
    voucher = Voucher.find(flash[:voucher_id])
    quantity = flash[:quantity].to_i
    
    vo = VoucherOffer.new(:user_id => current_user.id, :voucher_id => voucher.id, :accepted => true, :active => true, :quantity => quantity, :payment_profile_id => payer_id, :voucher_price_cents => voucher.voucher_price_cents, :amount_from_payment => flash[:paypal_purchase_amount], :amount_from_balance => flash[:balance_purchase_amount])
    vo.save
    if (voucher.purchase_count)
      voucher.purchase_count += quantity
    else
      voucher.purchase_count = quantity
    end
    referral = Referral.find_by_referee_id(current_user.id)
    if (referral && referral.voucher_id.nil?)
      referral.voucher_id = voucher.id
      referral.save
      referrer_user = User.find(referral.referrer_id)
      referrer_user.balance = referral.bonus_amount + referrer_user.balance
      referrer_user.save(false)
    end
    user = current_user
    user.balance = user.balance.to_i - flash[:balance_purchase_amount].to_i
    user.save
    voucher.save
    voucher_offer = VoucherOffer.find_last_by_user_id_and_voucher_id(current_user.id, voucher.id)
    Emailer.receipt(voucher_offer).deliver
    
    flash[:notice] = "Event ticket(s) purchased.  Please bring a photo ID with you to the venue to redeem your tickets, and  enjoy the show!"
    redirect_to '/account'
  end
       
  
  def buy
    if (!user_signed_in?)
      @user = User.new(params[:user])
      @user.save(false)
      if (cookies[:referral_code])
        referrer_user = User.find_by_referral_code(cookies[:referral_code])
        if (referrer_user)
          Referral.create(:referrer_id => referrer_user.id, :referee_id => @user.id)
        end
        cookies.delete(:referral_code)
      end
      sign_in(@user, :bypass => true)
    end

    voucher = Voucher.find(params[:id])
    quantity = params[:cart][:order_amount].to_i
    if (quantity.to_i > voucher.number_remaining)
      if (voucher.sold_out?)
        flash[:error_explanation] = "Unfortunately, the show you are trying to purchase tickets for has sold out at some point between when you clicked the Buy button, and when you completed your order (Talk about bad timing!).  We hope that another UsherBuddy event may pique your interest!"
        redirect_to "/home"
        return
      end
      if (quantity.to_i > 5)
        flash[:error_explanation] = "Wow!  You have a lot of friends!  Unfortunately, we only have " + (voucher.max_offers - voucher.purchase_count).to_s + " tickets left for this event in our inventory.  BUT, since you're so popular, we'd like to chat, and see if we can't work something out.  Give us a call at (646)-481-6829, and we might be able to speak to the venue directly on your behalf."
      else
        flash[:error_explanation] = "Unfortunately, only " + (voucher.max_offers - voucher.purchase_count).to_s + " ticket(s) are remaining for this event.  Please adjust your order accodingly.  Thanks!"
      end
      redirect_to :back
      return
    end
    user_id = current_user.id
    total = (quantity.to_i * voucher.voucher_price_cents.to_i)
    account_balance = User.find(user_id).balance.to_i
    if (account_balance < total)
      total -= account_balance
      account_balance = 0
    elsif (account_balance >= total)
      account_balance -= total
      total = 0
    end
    if (total <= 0)
      voucher.purchase(user_id, quantity.to_i, 0)
      flash[:notice] = "Event ticket(s) purchased.  Please bring a photo ID with you to the venue to redeem your tickets, and  enjoy the show!"
      redirect_to '/account'
    else
      commit_type = params[:commit]
      payment_profile_id = params[:cart][:profile_id]
      if (payment_profile_id != "paypal")
        if (!payment_profile_id)
          flash[:error_explanation] = "You must select or create a new payment profile in order to make a purchase."
          redirect_to :back
          return
        else
          if (payment_profile_id == "new")
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
            if after_payment_count == before_payment_count
              flash[:error_explanation] = "There was a problem with the credit card you provided.  Please double-check and try again."
              redirect_to :back
              return
            else
              payment_profile_id = PaymentProfile.find_all_by_user_id(user_id).last.id
            end
          end
          response = voucher.purchase(current_user.id, quantity.to_i, payment_profile_id.to_i)
          if (response == "Successful.")
            flash[:notice] = "Event ticket(s) purchased.  Please bring a photo ID with you to the venue to redeem your tickets, and  enjoy the show!"
            redirect_to '/account'
            return
          else
            flash[:error_explanation] = "There was a problem with your payment.  Please add a new payment method.  Details:  " + response
            redirect_to :back
            return
          end
        end
      elsif (payment_profile_id == "paypal")
        #purchase_amount = voucher.voucher_price_cents * quantity.to_i
        response = get_paypal_express_gateway.setup_purchase(total,
          :ip                => request.remote_ip,
          :return_url        => paypal_callback_url,
          :cancel_return_url => home_url
        )
        puts response.message
        flash[:paypal_purchase_amount] = total
        flash[:balance_purchase_amount] = voucher.voucher_price_cents.to_i * quantity.to_i - total
        flash[:voucher_id] = params[:id]
        flash[:quantity] = quantity
        redirect_to get_paypal_express_gateway.redirect_url_for(response.token)
      end
    end
  end
  
end
