class CreateBusinessAmenities < ActiveRecord::Migration
  def self.up
    create_table :business_amenities do |t|
      t.integer :business_id
      t.integer :amenity_id

      t.timestamps
    end
  end

  def self.down
    drop_table :business_amenities
  end
end
