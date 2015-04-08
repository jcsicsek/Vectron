class CreateDirectDepositProfiles < ActiveRecord::Migration
  def self.up
    create_table :direct_deposit_profiles do |t|
      t.string :bank_name
      t.integer :bank_account_type_id
      t.string :account_number
      t.string :routing_number
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :direct_deposit_profiles
  end
end
