class Venue < ActiveRecord::Base
  belongs_to :business
  has_many :vouchers
  has_many :event_templates
  
  def address_for_list
    "#{self.street_address.to_s}, #{self.city_address.to_s}, #{self.state.to_s} #{self.zip_code.to_s}"
  end
end
