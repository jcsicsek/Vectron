class AddSubscriberIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :subscriber_id, :integer
  end

  def self.down
    remove_column :users, :subscriber_id
  end
end
