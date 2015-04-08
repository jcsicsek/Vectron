class AddDefaultPaymentToUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :payment_profile_id, :default_payment_profile_id
  end

  def self.down
    rename_column :users, :default_payment_profile_id, :payment_profile_id
  end
end
