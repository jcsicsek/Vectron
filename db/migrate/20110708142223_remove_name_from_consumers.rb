class RemoveNameFromConsumers < ActiveRecord::Migration
  def self.up
    remove_column :consumers, :first_name
    remove_column :consumers, :last_name
  end

  def self.down
    add_column :consumers, :last_name, :string
    add_column :consumers, :first_name, :string
  end
end
