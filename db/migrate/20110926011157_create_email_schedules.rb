class CreateEmailSchedules < ActiveRecord::Migration
  def self.up
    create_table :email_schedules do |t|
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps
    end
  end

  def self.down
    drop_table :email_schedules
  end
end
