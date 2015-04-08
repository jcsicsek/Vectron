class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :email
      t.integer :city_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribers
  end
end
