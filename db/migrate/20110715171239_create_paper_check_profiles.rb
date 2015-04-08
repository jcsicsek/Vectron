class CreatePaperCheckProfiles < ActiveRecord::Migration
  def self.up
    create_table :paper_check_profiles do |t|
      t.string :street_address
      t.string :street_address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :paper_check_profiles
  end
end
