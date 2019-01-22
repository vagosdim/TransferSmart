class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.string :endpoint
      t.integer :savings

      t.timestamps
    end
  end
end
