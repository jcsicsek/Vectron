class CreatePaypalProfiles < ActiveRecord::Migration
  def self.up
    create_table :paypal_profiles do |t|
      t.string :paypal_username
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_profiles
  end
end
