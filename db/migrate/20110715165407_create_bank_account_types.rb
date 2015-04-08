class CreateBankAccountTypes < ActiveRecord::Migration
  def self.up
    create_table :bank_account_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_account_types
  end
end
