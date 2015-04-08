class RemoveColumnsFromVenue < ActiveRecord::Migration
  def self.up
    remove_column :venues, :website_url
    remove_column :venues, :twitter_handle
    remove_column :venues, :facebook_url
    remove_column :venues, :description
  end

  def self.down
    add_column :venues, :description, :text
    add_column :venues, :facebook_url, :string
    add_column :venues, :twitter_handle, :string
    add_column :venues, :website_url, :string
  end
end
