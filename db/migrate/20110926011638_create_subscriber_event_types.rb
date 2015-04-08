class CreateSubscriberEventTypes < ActiveRecord::Migration
  def self.up
    create_table :subscriber_event_types do |t|
      t.integer :subscriber_id
      t.integer :event_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriber_event_types
  end
end
