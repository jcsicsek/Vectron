class AddDefaultPaymentToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :default_payment_type_id, :integer
    add_column :businesses, :default_payment_profile_id, :integer
  end

  def self.down
    remove_column :businesses, :default_payment_profile_id
    remove_column :businesses, :default_payment_type_id
  end
end
