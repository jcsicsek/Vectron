class AddAmountsToVoucherOffer < ActiveRecord::Migration
  def self.up
    add_column :voucher_offers, :amount_from_payment, :integer
    add_column :voucher_offers, :amount_from_balance, :integer
  end

  def self.down
    remove_column :voucher_offers, :amount_from_balance
    remove_column :voucher_offers, :amount_from_payment
  end
end
