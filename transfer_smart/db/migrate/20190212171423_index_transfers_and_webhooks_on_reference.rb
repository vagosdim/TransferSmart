class IndexTransfersAndWebhooksOnReference < ActiveRecord::Migration[5.2]
  def change
  	add_index :transfers, :reference
  	add_index :webhooks, :reference
  	add_index :transfers, :id
  end
end
