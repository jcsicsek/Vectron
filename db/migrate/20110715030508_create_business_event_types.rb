class CreateBusinessEventTypes < ActiveRecord::Migration
  def self.up
    create_table :business_event_types do |t|
      t.integer :business_id
      t.integer :event_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :business_event_types
  end
end
