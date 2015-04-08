class AddTicketCutoffToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :ticket_cutoff, :integer
    add_column :vouchers, :ticket_cutoff, :integer
    add_column :event_templates, :ticket_cutoff, :integer
  end

  def self.down
    remove_column :businesses, :ticket_cutoff
    remove_column :vouchers, :ticket_cutoff
    remove_column :event_templates, :ticket_cutoff
  end
end
