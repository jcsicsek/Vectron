class AddLaunchedToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :launched, :boolean
  end

  def self.down
    remove_column :vouchers, :launched
  end
end
