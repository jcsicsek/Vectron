class EventTemplate < ActiveRecord::Base
  include ActionView::Helpers
  
  has_many :vouchers
  belongs_to :business
  belongs_to :event_type
  belongs_to :venue
  
  has_attached_file :photo,
  :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_protocol => "https",
    :path => ":attachment/:id/:style.:extension",
    :bucket => Rails.env.production? ? 'images.usherbuddy.com' : 'images.dev.usherbuddy.com'
  
  attr_accessor :photo_url, :launched, :voucher_price_cents, :max_offers, :time_only, :date_only, :event_template_id
  
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
  
  def sortable_date
    if (self.from_date)
      self.from_date.strftime("%b %d, %Y %H:%M")
    else
      self.created_at.strftime("%b %d, %Y %H:%M")
    end
  end
  
  def event_template_id
    self.id
  end
  
  def format_date_range
    from = self.from_date ? self.from_date.strftime("%b %d, %Y") : self.created_at.strftime("%b %d, %Y")
    to = self.to_date ? self.to_date.strftime("%b %d, %Y") : "Ongoing"
    from + " - " + to
  end
  
  def format_normal_price
    if (self.full_value_cents)
      number_to_currency(self.full_value_cents / 100.0)
    else
      ""
    end
  end
  
  def datepicker_from
    if(self.from_date)
      self.from_date.strftime("%m/%d/%Y")
    else
      ""
    end
  end
  
  def datepicker_to
    if(self.to_date)
      self.to_date.strftime("%m/%d/%Y")
    else
      ""
    end
  end
  
  def format_date_added
    if (self.created_at)
      self.created_at.strftime("%A, %B %d, %Y")
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
  
  
  def truncated_description
    if (self.description)
      if (self.description.size > 210)
        self.description[0..160]
      else
        self.description
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
        self.details[0..160]
      else
        self.details
      end
    else
      ""
    end
  end
  
  def details_truncated?
    self.details && self.details.size > 210
  end
  
  
end
