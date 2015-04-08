class AddActiveToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :active, :boolean
  end

  def self.down
    remove_column :businesses, :active
  end
end
