class AddExtIdAndGenreToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :external_id, :integer
    add_column :vouchers, :genre, :string
  end

  def self.down
    remove_column :vouchers, :genre
    remove_column :vouchers, :external_id
  end
end
