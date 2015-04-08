require 'active_merchant'

class PaymentProfile < ActiveRecord::Base
  include ActiveMerchant::Billing
  include ActiveMerchant::Utils
  belongs_to :user
  has_many :voucher_offers

  attr_accessor :address
  attr_accessor :credit_card

  validates_presence_of :user_id, :credit_card, :address

  def create
    if super and create_payment_profile
      #user.update_attributes({:payment_profile_id => self.id})
      return true
    else
      if self.id
        #destroy the instance if it was created
        self.destroy
      end
      return false
    end
  end

  def update
    if super and update_payment_profile
      return true
    end
    return false
  end

  def destroy
    if delete_payment_profile and super
      return true
    end
    return false
  end
  
  def get_cc_number
    payment_profile = get_payment_gateway.get_customer_payment_profile(:customer_profile_id => self.user.customer_cim_id, :customer_payment_profile_id => self.payment_cim_id)
    if (payment_profile.params['payment_profile'])
      number = payment_profile.params['payment_profile']['payment']['credit_card']['card_number']
      "XXXX-XXXX-XXXX-" + number[4,7]
    else
      "Not found on the Authorize.net server."
    end
  end
  
  def print_date_added
    self.updated_at.strftime("%A, %B %d, %Y at %I:%M %p")
  end
    

  #private
  def create_payment_profile
    #if not self.payment_cim_id
    #  return false
    #end
    @gateway = get_payment_gateway

    @profile = {:customer_profile_id => self.user.customer_cim_id,
                :payment_profile => {:bill_to => self.address,
                                     :payment => {:credit_card => CreditCard.new(self.credit_card)}
                                     }
                }
    response = @gateway.create_customer_payment_profile(@profile)
    if response.success? and response.params['customer_payment_profile_id']
      puts response.message
      self.payment_cim_id = response.params['customer_payment_profile_id']
      self.save
      self.address = {}
      self.credit_card = {}
      return true
    end
    puts response.message
    return false
  end

  def update_payment_profile
    @gateway = get_payment_gateway

    @profile = {:customer_profile_id => self.user.customer_cim_id,
                :payment_profile => {:customer_payment_profile_id => self.payment_cim_id,
                                     :bill_to => self.address,
                                     :payment => {:credit_card => CreditCard.new(self.credit_card)}
                                     }
                }
    response = @gateway.update_customer_payment_profile(@profile)
    if response.success?
      self.address = {}
      self.credit_card = {}
      return true
    end
    return false
  end

  def delete_payment_profile
    @gateway = get_payment_gateway

    response = @gateway.delete_customer_payment_profile(:customer_profile_id => self.user.customer_cim_id,
                                                        :customer_payment_profile_id => self.payment_cim_id)
    if response.success?
      #self.user.update_attributes({:payment_profile_id => nil})
      return true
    end
    return false
  end
end
