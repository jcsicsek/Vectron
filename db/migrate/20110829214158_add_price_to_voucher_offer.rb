class AddPriceToVoucherOffer < ActiveRecord::Migration
  def self.up
    add_column :voucher_offers, :voucher_price_cents, :integer
  end

  def self.down
    remove_column :voucher_offers, :voucher_price_cents
  end
end
