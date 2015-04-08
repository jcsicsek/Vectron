class AddTextToVouchers < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :description, :text
    add_column :vouchers, :details, :text
    add_column :vouchers, :terms, :text
  end

  def self.down
    remove_column :vouchers, :terms
    remove_column :vouchers, :details
    remove_column :vouchers, :description
  end
end
