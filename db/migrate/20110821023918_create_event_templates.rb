class CreateEventTemplates < ActiveRecord::Migration
  def self.up
    create_table :event_templates do |t|
      t.integer :business_id
      t.integer :event_type_id
      t.string :name
      t.datetime :event_time
      t.integer :full_value_cents
      t.boolean :active
      t.text :description
      t.text :details
      t.text :terms
      t.integer :external_id
      t.string :genre
      t.string :photo_remote_url

      t.timestamps
    end
  end

  def self.down
    drop_table :event_templates
  end
end
