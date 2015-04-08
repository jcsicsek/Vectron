class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.string :street_address
      t.string :street_address_2
      t.string :city_address
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :neighborhood
      t.string :website_url
      t.string :twitter_handle
      t.string :facebook_url
      t.text :description
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
