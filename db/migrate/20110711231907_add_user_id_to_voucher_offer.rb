class AddUserIdToVoucherOffer < ActiveRecord::Migration
  def self.up
    add_column :voucher_offers, :user_id, :integer
  end

  def self.down
    remove_column :voucher_offers, :user_id
  end
end
