class AddStatusToTransfers < ActiveRecord::Migration[5.2]
  def change
  	add_column :transfers, :status, :string
  	remove_column :transfers, :completed
  end
end
