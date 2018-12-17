class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.integer :user_id
      t.integer :recipient_info_id
      t.integer :personal_info_id
      t.integer :exchange_info_id
      t.integer :account_number
      t.string :reference
      t.string :bank_name

      t.timestamps
    end
  end
end
