class CreateUserEventTypes < ActiveRecord::Migration
  def self.up
    create_table :user_event_types do |t|
      t.integer :user_id
      t.integer :event_type_id
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :user_event_types
  end
end
