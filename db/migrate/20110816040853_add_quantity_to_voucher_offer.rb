class AddQuantityToVoucherOffer < ActiveRecord::Migration
  def self.up
    add_column :voucher_offers, :quantity, :integer
  end

  def self.down
    remove_column :voucher_offers, :quantity
  end
end
