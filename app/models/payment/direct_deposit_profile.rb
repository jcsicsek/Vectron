class DirectDepositProfile < ActiveRecord::Base
  belongs_to :bank_account_type
  
  validates_presence_of :bank_name, :bank_account_type_id, :account_number, :routing_number
  
  def masked_account_number
    length = self.account_number.length
    self.account_number[length - 4, length].rjust(length, "X")
  end
    
  def masked_routing_number
    length = self.routing_number.length
    self.routing_number[length - 4, length].rjust(length, "X")
  end
  
  def is_default?(business)
    business.default_payment_type_id == PaymentType.find_by_name("Direct Deposit").id && business.default_payment_profile_id == self.id
  end
  
  def set_default(business)
    business.default_payment_type_id = PaymentType.find_by_name("Direct Deposit").id
    business.default_payment_profile_id = self.id
    business.save
  end
  
  def print_type
    "Direct Deposit"
  end
  
  def print_date_added
    self.updated_at.strftime("%A, %B %d, %Y at %I:%M %p")
  end
end
