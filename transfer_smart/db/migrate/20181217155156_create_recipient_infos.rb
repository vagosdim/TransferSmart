class CreateRecipientInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :recipient_infos do |t|
      t.integer :transfer_id
      t.string :name
      t.string :email
      t.string :iban
      t.string :bank_code
      t.text :description

      t.timestamps
    end
  end
end
