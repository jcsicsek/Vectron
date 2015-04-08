class PrintController < ApplicationController
  before_filter :authenticate_user!, :only => [:voucher]
  before_filter :authenticate_business!, :only => [:event_dashboard]
  layout false
  
  def voucher
    voucher_offer = VoucherOffer.find(params[:id])
    business = voucher_offer.voucher.business
    venue = voucher_offer.voucher.venue
    
    @event_tagline = voucher_offer.voucher.format_tagline
    @date = voucher_offer.voucher.format_date_only
    @time = voucher_offer.voucher.format_time_only
    @full_name = voucher_offer.user.first_name + " " + voucher_offer.user.last_name
    @quantity = voucher_offer.quantity
    @price = voucher_offer.format_total_price
    if (voucher_offer.amount_from_payment.to_i <= 0)
      @payment_details = voucher_offer.format_amount_from_balance + " in UsherBuddy Credit"
    else
      if (voucher_offer.payment_profile)
        @payment_details = voucher_offer.format_amount_from_payment + " from credit card " + voucher_offer.payment_profile.get_cc_number
      else
        @payment_details = voucher_offer.format_amount_from_payment + " from your PayPal account"
      end
      if (voucher_offer.amount_from_balance.to_i > 0)
        @payment_details += ", " + voucher_offer.format_amount_from_balance + " in UsherBuddy Credit"
      end
    end
    @voucher_code = voucher_offer.ticket_id
    @street_address = voucher_offer.voucher.venue.street_address
    @city_state_zip = venue.city_address.to_s + ", " + venue.state.to_s + " " + venue.zip_code.to_s
    @terms = voucher_offer.voucher.terms
    @business_name = venue.name
  end
  
  def event_dashboard
    @voucher = Voucher.find(params[:id])
    if (current_business.id != @voucher.business_id)
      redirect_to business_login_path
    end
    @title = "UsherBuddy | Print Guestlist and Promotion Status for " + @voucher.name
  end
end
