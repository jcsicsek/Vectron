class AddPromoIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :promo_id, :integer
  end

  def self.down
    remove_column :users, :promo_id
  end
end
