class AddEveryToPromo < ActiveRecord::Migration
  def self.up
    add_column :promos, :every, :integer
  end

  def self.down
    remove_column :promos, :every
  end
end
