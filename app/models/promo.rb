class Promo < ActiveRecord::Base
  include ActionView::Helpers
    
  has_many :users
  has_many :subscribers
  
  def display_name
    self.name.to_s.split("-").each{|word| word.capitalize!}.join(" ")
  end
  
  def display_credit
    number_to_currency(self.credit.to_i / 100.0)
  end
  
end
