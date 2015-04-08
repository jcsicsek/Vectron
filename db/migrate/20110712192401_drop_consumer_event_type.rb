class DropConsumerEventType < ActiveRecord::Migration
  def self.up
    drop_table :consumer_event_types
  end

  def self.down
  end
end
