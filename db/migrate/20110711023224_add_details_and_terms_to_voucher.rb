class AddDetailsAndTermsToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :details, :string
    add_column :vouchers, :terms, :string
  end

  def self.down
    remove_column :vouchers, :terms
    remove_column :vouchers, :details
  end
end
