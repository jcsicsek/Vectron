class AddZipToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :zip_code, :string
  end

  def self.down
    remove_column :users, :zip_code
  end
end
