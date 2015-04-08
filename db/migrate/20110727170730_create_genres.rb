class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.integer :event_type_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :genres
  end
end
