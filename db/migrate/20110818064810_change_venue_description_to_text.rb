class ChangeVenueDescriptionToText < ActiveRecord::Migration
  def self.up
    remove_column :businesses, :description
    add_column :businesses, :description, :text
  end

  def self.down
    remove_column :businesses, :description
    add_column :businesses, :description, :string
  end
end
