class PaypalProfile < ActiveRecord::Base
  
  validates_presence_of :paypal_username
  validates_format_of :paypal_username, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  
  def is_default?(business)
    business.default_payment_type_id == PaymentType.find_by_name("Paypal").id && business.default_payment_profile_id == self.id
  end
  
  def set_default(business)
    business.default_payment_type_id = PaymentType.find_by_name("Paypal").id
    business.default_payment_profile_id = self.id
    business.save
  end
  
  def print_type
    "PayPal"
  end
  
  def print_date_added
    self.updated_at.strftime("%A, %B %d, %Y at %I:%M %p")
  end
  
end
