class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :name
      t.integer :max_offers
      t.integer :redeemed_offers
      t.integer :credit
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
