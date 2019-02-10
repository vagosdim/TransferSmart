class RemoveBankNameFromTransfers < ActiveRecord::Migration[5.2]
  def change
	remove_column :transfers, :bank_name
  end
end
