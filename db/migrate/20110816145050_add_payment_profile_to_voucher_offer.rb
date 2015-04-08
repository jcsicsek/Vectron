class AddPaymentProfileToVoucherOffer < ActiveRecord::Migration
  def self.up
    add_column :voucher_offers, :payment_profile_id, :integer
  end

  def self.down
    remove_column :voucher_offers, :payment_profile_id
  end
end
