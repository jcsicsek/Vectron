class Cleanup < ActiveRecord::Migration
  def self.up
    drop_table :administrators
    drop_table :systems
    drop_table :relationships
    drop_table :relationship_types
    drop_table :message_contents
    drop_table :message_types
    drop_table :message_recipients
    drop_table :interest_levels
    drop_table :consumers
  end

  def self.down
  end
end
