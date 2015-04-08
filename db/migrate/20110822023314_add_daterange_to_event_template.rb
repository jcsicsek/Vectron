class AddDaterangeToEventTemplate < ActiveRecord::Migration
  def self.up
    add_column :event_templates, :from_date, :datetime
    add_column :event_templates, :to_date, :datetime
  end

  def self.down
    remove_column :event_templates, :to_date
    remove_column :event_templates, :from_date
  end
end
