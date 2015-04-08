class AddCimIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :customer_cim_id, :string
    add_column :users, :payment_profile_id, :integer
  end

  def self.down
    remove_column :users, :payment_profile_id
    remove_column :users, :customer_cim_id
  end
end
