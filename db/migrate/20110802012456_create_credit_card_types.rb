class CreateCreditCardTypes < ActiveRecord::Migration
  def self.up
    create_table :credit_card_types do |t|
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_card_types
  end
end
