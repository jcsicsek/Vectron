class VoucherOffer < ActiveRecord::Base
  include ActionView::Helpers
    
  belongs_to :voucher
  belongs_to :user
  belongs_to :payment_profile
  
  def get_cc_number
    if (self.payment_profile)
      self.payment_profile.get_cc_number
    else
      "Payment profile has been deleted."
    end
  end
  
  def print_payment_info
    if (self.payment_profile)
      self.payment_profile.get_cc_number
    else
      if (self.amount_from_payment == 0)
        "UsherBuddy credit"
      else
        "PayPal"
      end
    end
  end
  
  def format_grand_total
    grand_total = self.amount_from_balance.to_i + self.amount_from_payment.to_i
    number_to_currency(grand_total / 100.0)
  end
  
  def format_amount_from_balance
    if (self.amount_from_balance)
      number_to_currency(self.amount_from_balance / 100.0)
    else
      ""
    end
  end
  
  def format_amount_from_payment
    if (self.amount_from_payment)
      number_to_currency(self.amount_from_payment / 100.0)
    else
      ""
    end
  end
  
  def format_discount_price
    if (self.voucher_price_cents)
      number_to_currency(self.voucher_price_cents / 100.0)
    else
      ""
    end
  end
  
  def format_total_price
    if (self.voucher_price_cents)
      number_to_currency((self.voucher_price_cents * self.quantity.to_i) / 100.0)
    else
      ""
    end
  end
  
  def print_ub_revenue
    number_to_currency((self.voucher_price_cents.to_i / 100.0) * self.quantity.to_i)
  end
  
  def print_revenue
    number_to_currency((1.0 - self.voucher.commission.to_f) * (self.voucher_price_cents.to_i / 100.0) * self.quantity.to_i)
  end
  
  def print_commission
    number_to_currency((self.voucher.commission.to_f) * (self.voucher_price_cents.to_i / 100.0) * self.quantity.to_i)
  end
  
  def format_purchase_date
    self.created_at.strftime("%B %d, %Y")
  end
  
  def ticket_id
    self.voucher.event_time.strftime("%m%d%y") + "-" + self.voucher.id.to_s + "-" + self.id.to_s
  end
  
  def print_date_added
    self.created_at.strftime("%A, %B %d, %Y at %I:%M %p")
  end
  
end
