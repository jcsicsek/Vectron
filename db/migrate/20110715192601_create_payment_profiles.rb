class CreatePaymentProfiles < ActiveRecord::Migration
  def self.up
    create_table :payment_profiles do |t|
      t.string :payment_cim_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_profiles
  end
end
