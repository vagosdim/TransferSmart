class CreateExchangeInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_infos do |t|
      t.integer :transfer_id
      t.decimal :sending_amount
      t.decimal :receiving_amount
      t.string :currency_from
      t.string :currency_to
      t.decimal :exchange_rate

      t.timestamps
    end
  end
end
