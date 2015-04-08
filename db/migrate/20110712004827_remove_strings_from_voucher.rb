class RemoveStringsFromVoucher < ActiveRecord::Migration
  def self.up
    remove_column :vouchers, :description
    remove_column :vouchers, :details
    remove_column :vouchers, :terms
  end

  def self.down
    add_column :vouchers, :terms, :string
    add_column :vouchers, :details, :string
    add_column :vouchers, :description, :string
  end
end
