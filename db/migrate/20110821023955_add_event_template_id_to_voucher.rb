class AddEventTemplateIdToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :event_template_id, :integer
  end

  def self.down
    remove_column :vouchers, :event_template_id
  end
end
