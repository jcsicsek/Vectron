

require 'open-uri'

class Voucher < ActiveRecord::Base
  include ActionView::Helpers
  include ActiveMerchant::Billing
  include ActiveMerchant::Utils
  
  belongs_to :business
  belongs_to :venue
  belongs_to :event_type
  has_many :voucher_offers
  has_many :users, :through => :voucher_offers
  has_many :thumbs
  belongs_to :event_template
  has_attached_file :photo,
  :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_protocol => "https",
    :path => "event/:attachment/:id/:style.:extension",
    :bucket => Rails.env.production? ? 'images.usherbuddy.com' : 'images.dev.usherbuddy.com'
  
  attr_accessor :photo_url, :time_only, :date_only, :business_active
  
  before_validation :download_remote_photo, :if => :photo_url_provided?

  validates_presence_of :photo_remote_url, :if => :photo_url_provided?, :message => 'is invalid or inaccessible'
  
  validates_presence_of :event_type_id, :name, :description, :event_time, :full_value_cents
  
  #validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  def business_active
    if (!self.business.active.nil?)
      self.business.active
    else
      false
    end
  end
  
  def api_hash
    {
      :text => self.format_title,
      :model => "Voucher",
      :info => self.description,
      :leaf => true,
      :event_name => self.name,
      :venue_name => self.venue.name,
      :neighborhood => self.business.neighborhood,
      :event_time => self.format_event_date,
      :voucher_price => self.format_discount_price,
      :offers_available => self.max_offers,
      :offers_purchased => self.purchase_count,
      :photo_url => self.photo.url,
      :items => Array.new
    }
  end
  
  def sold_out?
    self.max_offers.to_i - self.purchase_count.to_i <= 0 || self.event_time - self.ticket_cutoff.to_i.minutes <= Time.now
  end
  
  def number_remaining
    self.max_offers.to_i - self.purchase_count.to_i
  end
  
  def total_revenue_cents
    revenue = 0.0
    self.voucher_offers.each do |voucher_offer|
      revenue += voucher_offer.voucher_price_cents.to_f
    end
    revenue
  end
  
  def print_ub_revenue
    number_to_currency(self.total_revenue_cents.to_i / 100.0)
  end
  
  def print_revenue
    number_to_currency((1.0 - self.commission.to_f) * (self.total_revenue_cents.to_i / 100.0))
  end
  
  def print_commission
    number_to_currency((self.commission.to_f) * (self.total_revenue_cents.to_i / 100.0))
  end
  
  def get_photo_url
    if (self.new_record?)
      ""
    elsif (self.photo_file_name && !self.photo_file_name.empty?)
      self.photo.url
    elsif (self.photo_remote_url && !self.photo_remote_url.empty?)
      self.photo_remote_url
    elsif (self.business.get_photo_url && !self.business.get_photo_url.empty?)
      self.business.get_photo_url
    else
      if (self.event_type == EventType.find_by_name("Comedy"))
        "/images/feat-comedy.jpg"
      elsif (self.event_type == EventType.find_by_name("Live Music"))
        "/images/feat-music.jpg"
      else (self.event_type == EventType.find_by_name("Theater"))
        "/images/feat-theater.jpg"
      end
    end
  end
  
  def photo_url_provided?
    !self.photo_url.blank?
  end

  def download_remote_photo
    self.photo = do_download_remote_photo
    self.photo_remote_url = photo_url
  end

  def do_download_remote_photo
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  
  def purchase(user_id, quantity, payment_profile_id)
    gateway = get_payment_gateway
    total = (quantity * self.voucher_price_cents)
    user = User.find(user_id)
    account_balance = user.balance.to_i
    if (account_balance < total)
      total -= account_balance
      amount_from_payment = total
      amount_from_balance = account_balance
      account_balance = 0
    elsif (account_balance >= total)
      account_balance -= total
      amount_from_payment = 0
      amount_from_balance = total
      total = 0
    else
      amount_from_payment = total
      amount_from_balance = 0
    end
    user.balance = account_balance.to_i
    user.save(false)
    if (total > 0)
      amount = total / 100.0
      customer_profile_id = User.find(user_id).customer_cim_id
      customer_payment_profile_id = PaymentProfile.find(payment_profile_id).payment_cim_id
    
      response = gateway.create_customer_profile_transaction({:transaction => {:type => :auth_capture,
                                                               :amount => amount.to_s,
                                                               :customer_profile_id => customer_profile_id,
                                                               :customer_payment_profile_id => customer_payment_profile_id}})
      response_message = response.message
    else
      response_message = "Successful."
    end
                                                             
    #if response.success? and response.authorization
      if (response_message == "Successful.")
        VoucherOffer.new(:user_id => user_id, :voucher_id => self.id, :accepted => true, :active => true, :quantity => quantity, :payment_profile_id => payment_profile_id, :voucher_price_cents => self.voucher_price_cents, :amount_from_payment => amount_from_payment, :amount_from_balance => amount_from_balance).save
        if (self.purchase_count)
          self.purchase_count += quantity
        else
          self.purchase_count = quantity
        end
        self.save
        voucher_offer = VoucherOffer.find_last_by_user_id_and_voucher_id(user_id, self.id)
        referral = Referral.find_by_referee_id(user_id)
        if (referral && referral.voucher_id.nil?)
          referral.voucher_id = self.id
          referral.save
          referrer_user = User.find(referral.referrer_id)
          referrer_user.balance = referral.bonus_amount + referrer_user.balance
          referrer_user.save(false)
        end
        Emailer.receipt(voucher_offer).deliver
      end
      #update_attributes({:confirmation_id => response.authorization})
      #return "Purchase completed successfully."
    #else
      #update_attributes({:error => !response.success?,
      #                  :error_code => response.params['messages']['message']['code'],
      #                  :error_message => response.params['messages']['message']['text']})
     # return "An error has occurred for this transaction:  " + response.message
    #end
    return response_message
  end
    
  #returns an array with one voucher for each event_type
  def self.get_featured(event_type_id)
    Voucher.joins(:business).where("event_type_id = ? AND vouchers.active = ? AND launched = ? AND event_time >= ? AND event_time <= ? AND businesses.active = ?", event_type_id, true, true, Time.now, Chronic.parse("Two days from now"), true).order("event_time ASC").limit(1).first
    #Voucher.where(:event_type_id => event_type_id, :active => true).order("event_time DESC").limit(1).first
  end
  
  def self.get_unfeatured(event_type_id)
    Voucher.joins(:business).where("event_type_id = ? AND vouchers.active = ? AND launched = ? AND event_time >= ? AND event_time <= ? AND businesses.active = ?", event_type_id, true, true, Time.now, Chronic.parse("Two days from now"), true).order("event_time ASC")
  end
  
  def self.import_from_offoffonline
    scraper_results = ScrapeOffoffonline.scrape_shows
    scraper_results.each do |event|
      if (!Voucher.find_by_external_id(event[:external_id]))
        venue_name = event[:venue]
        business = Business.find_by_name(venue_name)
        if (!business)
          business_id = Business.create_skeleton(venue_name)
        else
          business_id = business.id
        end
        voucher = Voucher.new
        voucher.business_id = business_id
        voucher.genre = event[:category]
        voucher.name = event[:name]
        voucher.event_type = EventType.find_by_name("Comedy")
        voucher.description = event[:synopsis]
        voucher.details = event[:cast_crew]
        voucher.photo_remote_url = event[:image_url]
        voucher.event_time = Chronic.parse("one day from now")
        voucher.active = true
        voucher.purchase_count = 0
        voucher.commission = 0.35
        voucher.save(false)
      end
    end
      
  end
  
  def share_url(user_id = nil)
    rv = "http://www.usherbuddy.com/deal/" + self.id.to_s
    if (user_id)
      user = User.find(user_id)
      if (user)
        rv += "?share=" + user.referral_code.to_s
      end
    end
    return rv
  end
  
  def twitter_url(user_id = nil)
    venue_name = (self.business.twitter_handle && !self.business.twitter_handle.empty?) ? "@" + self.business.twitter_handle : self.venue.name
    twitter_message = self.format_discount_price + " to see " + self.name + " at " + venue_name + " in " + self.venue.neighborhood.to_s + " http://www.usherbuddy.com/deal/" + self.id.to_s
    if (user_id)
      user = User.find(user_id)
      if (user)
        twitter_message += "?share=" + user.referral_code.to_s
      end
    end
    twitter_message += " via @UsherBuddy!"
    "http://twitter.com/home?status=" + URI.escape(twitter_message)
  end
  
  def facebook_url(user_id = nil)
    rv = "http://www.facebook.com/share.php?u=" + "http://www.usherbuddy.com/deal/" + self.id.to_s
    if (user_id)
      user = User.find(user_id)
      if (user)
        rv += "?share=" + user.referral_code.to_s
      end
    end
    return rv
  end
  
  def full_description
    if (self.description)
      self.description
    else
      ""
    end
  end
  
  def full_details
    if (self.details)
      self.details
    else
      ""
    end
  end
  
  def truncated_description
    if (self.description)
      if (self.description.size > 210)
        self.description[0..160] + '...   <br>' + link_to("Read more...", "/deal/" + self.id.to_s)
      else
        self.description + '...   <br>' + link_to("Read more...", "/deal/" + self.id.to_s)
      end
    else
      ""
    end
  end
  
  def description_truncated?
    self.description && self.description.size > 210
  end
  
  def truncated_details
    if (self.details)
      if (self.details.size > 210)
        self.details[0..160] + '...   <br>' + link_to("Read more...", "/deal/" + self.id.to_s)
      else
        self.details + '...   <br>' + link_to("Read more...", "/deal/" + self.id.to_s)
      end
    else
      ""
    end
  end
  
  def details_truncated?
    self.details && self.details.size > 210
  end
  
  def format_date_added
    if (self.created_at)
      self.created_at.strftime("%A, %B %d, %Y")
    else
      ""
    end
  end
  
  def format_date_only
    if (self.event_time)
      self.event_time.strftime("%A, %B %d, %Y")
    else
      ""
    end
  end
  
  def format_time_only
    if (self.event_time)
      self.event_time.strftime("%I:%M %p")
    else
      ""
    end
  end
  
  def format_event_date
    if (self.event_time)
      self.event_time.strftime("%A, %B %d, %Y at %I:%M %p")
    else
      ""
    end
  end
  
  def js_event_date
    if(self.event_time)
      (self.event_time - self.ticket_cutoff.to_i.minutes).strftime("%b %d, %Y %H:%M")
    else
      ""
    end
  end
  
  def format_table_date
    if (self.event_time)
      (self.event_time.strftime("%b %d, %Y") + ' <span class="no_display">' + self.event_time.strftime("%H:%M") + "</span>").html_safe
    else
      ""
    end
  end
  
  def datepicker_date_only
    if(self.event_time)
      self.event_time.strftime("%m/%d/%Y")
    else
      ""
    end
  end
  
  def timepicker_time_only
    if(self.event_time)
      self.event_time.strftime("%I:%M %p")
    else
      ""
    end
  end
  
  def datepicker_date
    if(self.event_time)
      self.event_time.strftime("%m/%d/%Y %I:%M %p")
    else
      ""
    end
  end
  
  def sortable_date
    if (self.event_time)
      self.event_time.strftime("%b %d, %Y %H:%M")
    else
      ""
    end
  end
  
  #String Formatting Helpers
  
  def format_discount_price
    if (self.voucher_price_cents)
      number_to_currency(self.voucher_price_cents / 100.0)
    else
      ""
    end
  end
  
  def format_normal_price
    if (self.full_value_cents)
      number_to_currency(self.full_value_cents / 100.0)
    else
      ""
    end
  end
  
  def format_total_price(quantity)
    if (self.voucher_price_cents)
      number_to_currency((self.voucher_price_cents * quantity.to_i) / 100.0)
    else
      ""
    end
  end
  
  def format_percent_savings
    if (self.full_value_cents && self.voucher_price_cents)
      number_to_percentage(100 * (self.full_value_cents - self.voucher_price_cents) / self.full_value_cents, :precision => 0)
    else
      ""
    end
  end
  
  def format_dollar_savings
    if (self.full_value_cents && self.voucher_price_cents)
      number_to_currency((self.full_value_cents - self.voucher_price_cents) / 100.0)
    else
      ""
    end
  end
  
  def format_title
    if (self.venue)
      if (self.venue.neighborhood)
        neighborhood = self.venue.neighborhood
      else
        neighborhood = ""
      end
      self.name + " at " + self.venue.name + " in " + neighborhood
    else
      self.name
    end
  end
  
  def format_blurb
    self.format_tagline + " at " + self.format_time_only
  end
  
  def format_tagline
    self.format_discount_price + " to see " + self.format_title
  end
end
