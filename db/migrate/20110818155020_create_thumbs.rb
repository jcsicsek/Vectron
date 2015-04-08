class CreateThumbs < ActiveRecord::Migration
  def self.up
    create_table :thumbs do |t|
      t.boolean :up
      t.boolean :down
      t.integer :user_id
      t.integer :voucher_id

      t.timestamps
    end
  end

  def self.down
    drop_table :thumbs
  end
end
