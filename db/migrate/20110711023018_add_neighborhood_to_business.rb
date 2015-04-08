class AddNeighborhoodToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :neighborhood, :string
  end

  def self.down
    remove_column :businesses, :neighborhood
  end
end
