class CreditCardForm
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  
  attr_accessor :phone, :first_name, :last_name, :card_number, :card_type, :security_code, :expiry_month, :expiry_year, :address, :city, :state, :zip
  
  validates_presence_of :first_name, :last_name, :card_number, :card_type, :security_code, :expiry_month, :expiry_year, :zip
  #validates_presence_of  :address, :city, :state
  validates_length_of :card_number, :minimum => 12, :maximum => 20
  validates_length_of :expiry_month, :minimum => 1, :maximum => 2
  validates_length_of :expiry_year, :minimum => 4, :maximum => 4
  validates_length_of :zip, :minimum => 5, :maximum => 5
  validates_length_of :security_code, :minimum => 3, :maximum => 4
  
  def persisted?
    false
  end
  
end
