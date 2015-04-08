class AddTwitterFacebookToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :twitter_handle, :string
    add_column :businesses, :facebook_url, :string
  end

  def self.down
    remove_column :businesses, :facebook_url
    remove_column :businesses, :twitter_handle
  end
end
