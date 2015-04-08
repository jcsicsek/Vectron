class AddPromoIdToSubscriber < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :promo_id, :integer
  end

  def self.down
    remove_column :subscribers, :promo_id
  end
end
