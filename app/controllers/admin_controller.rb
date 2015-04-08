class AdminController < ApplicationController
  #include ActionView::Helpers
  
  before_filter :authenticate_admin!
  
  def activate_business
    business = Business.find(params[:id])
    business.active = true
    business.save(false)
    flash[:notice] = "#{business.name} has been activated."
    redirect_to admin_path
  end
  
  def business_signin
    business = Business.find(params[:id])
    sign_in(business, :bypass => true)
    redirect_to business_account_path
  end
  
  def home
    @businesses = Business.all
    @voucher_offers = VoucherOffer.all
    
    @user_count = User.count
    @weekly_active_users = User.where("last_sign_in_at > ?", Chronic.parse("One week ago")).count
    
    @subscriber_count = Subscriber.count
    
    @users_with_purchase = VoucherOffer.find(:all, :select => "DISTINCT(user_id)").count
    @purchases_per_user = VoucherOffer.count.to_f / @users_with_purchase.to_f
    
    total_tickets_purchased = 0
    VoucherOffer.all.each do |voucher_offer|
      total_tickets_purchased += voucher_offer.quantity.to_i
    end
    @tickets_per_order = total_tickets_purchased.to_f / VoucherOffer.count.to_f
    
    total_revenue = 0.0
    Voucher.all.each do |voucher|
      total_revenue += voucher.purchase_count.to_i * voucher.voucher_price_cents.to_i
    end
    @revenue_per_order = ((total_revenue / 100.0) / VoucherOffer.count)
    
    
    
    @business_count = Business.count
    @weekly_active_businesses = Business.where("last_sign_in_at > ?", Chronic.parse("One week ago")).count

    
    if Rails.env.production?
      @upcoming_event_templates = EventTemplate.where("(to_date >= ? OR to_date IS NULL) AND active = '1'", Time.now)
      @past_event_templates = EventTemplate.where("to_date < ? AND active = '1'", Time.now)
      @upcoming_all_events = Voucher.where("event_time >= ?", Time.now).order("event_time ASC")
      @past_all_events = Voucher.where("event_time < ?", Time.now)
    
      #These are for events with deals launched...
      @upcoming_launched_events = Voucher.where("event_time >= ? AND launched = '1'", Time.now).order("event_time ASC")
      @past_launched_events = Voucher.where("event_time < ? AND launched = '1'", Time.now)
    else
      @upcoming_event_templates = EventTemplate.where("(to_date >= ? OR to_date IS NULL) AND active = 't'", Time.now)
      @past_event_templates = EventTemplate.where("to_date < ? AND active = 't'", Time.now)
      @upcoming_all_events = Voucher.where("event_time >= ?", Time.now).order("event_time ASC")
      @past_all_events = Voucher.where("event_time < ?", Time.now)
    
      #These are for events with deals launched...
      @upcoming_launched_events = Voucher.where("event_time >= ? AND launched = 't'", Time.now).order("event_time ASC")
      @past_launched_events = Voucher.where("event_time < ? AND launched = 't'", Time.now)
    end
  end
end
