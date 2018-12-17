class CreateExchangeInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_infos do |t|
      t.integer :transfer_id
      t.decimal :sending_ammount
      t.decimal :receiving_ammount
      t.string :currency_from
      t.string :currency_to
      t.decimal :exchange_rate

      t.timestamps
    end
  end
end
