class AddDetailsToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :first_name, :string
    add_column :businesses, :last_name, :string
    add_column :businesses, :street_address_2, :string
    add_column :businesses, :website_url, :string
  end

  def self.down
    remove_column :businesses, :website_url
    remove_column :businesses, :street_address_2
    remove_column :businesses, :last_name
    remove_column :businesses, :first_name
  end
end
