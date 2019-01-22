class AddReferenceToWebhooks < ActiveRecord::Migration[5.2]
  def change
  	add_column :webhooks, :reference, :string
  end
end
