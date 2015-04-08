class AddVenueIdToEventTemplate < ActiveRecord::Migration
  def self.up
    add_column :event_templates, :venue_id, :integer
  end

  def self.down
    remove_column :event_templates, :venue_id
  end
end
