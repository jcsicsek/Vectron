class AddDemoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :gender_id, :integer
    add_column :users, :education_id, :integer
    add_column :users, :employment_id, :integer
    add_column :users, :income_id, :integer
    add_column :users, :house_id, :integer
    add_column :users, :relationship_status_id, :integer
    add_column :users, :children_id, :integer
  end

  def self.down
    remove_column :users, :children_id
    remove_column :users, :relationship_status_id
    remove_column :users, :house_id
    remove_column :users, :income_id
    remove_column :users, :employment_id
    remove_column :users, :education_id
    remove_column :users, :gender_id
  end
end
