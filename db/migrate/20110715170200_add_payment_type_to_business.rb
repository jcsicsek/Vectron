class AddPaymentTypeToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :payment_type_id, :integer
  end

  def self.down
    remove_column :businesses, :payment_type_id
  end
end
