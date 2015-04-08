class Cart
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  
  attr_accessor :order_amount, :profile_id
  
  def persisted?
    false
  end
  
end