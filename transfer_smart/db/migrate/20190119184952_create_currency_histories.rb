class CreateCurrencyHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_histories do |t|
      t.string :base
      t.string :target_currency
      t.decimal :convertion_to_base
      t.decimal :convertion_from_base
      t.decimal :percent_change

      t.timestamps
    end
  end
end
