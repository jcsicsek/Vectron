class AddEmailScheduleIdToSubscriber < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :email_schedule_id, :integer
    add_column :subscribers, :preferences_set, :boolean
    add_column :subscribers, :zip_code, :string
  end

  def self.down
    remove_column :subscribers, :email_schedule_id
    remove_column :subscribers, :preferences_set
    remove_column :subscribers, :zip_code
  end
end
