class AddNameToConsumers < ActiveRecord::Migration
  def self.up
    add_column :consumers, :first_name, :string
    add_column :consumers, :last_name, :string
  end

  def self.down
    remove_column :consumers, :last_name
    remove_column :consumers, :first_name
  end
end
