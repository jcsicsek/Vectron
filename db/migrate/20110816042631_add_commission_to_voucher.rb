class AddCommissionToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :commission, :float
  end

  def self.down
    remove_column :vouchers, :commission
  end
end
