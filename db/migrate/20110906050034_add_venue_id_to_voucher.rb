class AddVenueIdToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :venue_id, :integer
  end

  def self.down
    remove_column :vouchers, :venue_id
  end
end
