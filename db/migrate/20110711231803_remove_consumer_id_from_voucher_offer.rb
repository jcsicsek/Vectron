class RemoveConsumerIdFromVoucherOffer < ActiveRecord::Migration
  def self.up
    remove_column :voucher_offers, :consumer_id
  end

  def self.down
    add_column :voucher_offers, :consumer_id, :integer
  end
end
