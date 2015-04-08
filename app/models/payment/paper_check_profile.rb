class PaperCheckProfile < ActiveRecord::Base
  
  validates_presence_of :street_address, :city, :state, :zip_code, :phone_number
  
  def is_default?(business)
    business.default_payment_type_id == PaymentType.find_by_name("Paper Check via USPS").id && business.default_payment_profile_id == self.id
  end
  
  def set_default(business)
    business.default_payment_type_id = PaymentType.find_by_name("Paper Check via USPS").id
    business.default_payment_profile_id = self.id
    business.save
  end
  
  def print_type
    "Paper Check"
  end

  def print_date_added
    self.updated_at.strftime("%A, %B %d, %Y at %I:%M %p")
  end
  
end
