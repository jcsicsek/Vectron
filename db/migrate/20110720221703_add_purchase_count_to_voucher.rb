class AddPurchaseCountToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :purchase_count, :integer
  end

  def self.down
    remove_column :vouchers, :purchase_count
  end
end
