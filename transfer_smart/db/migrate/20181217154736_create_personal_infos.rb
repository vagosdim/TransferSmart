class CreatePersonalInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_infos do |t|
      t.integer :transfer_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :country
      t.string :city
      t.string :address
      t.string :postal_code

      t.timestamps
    end
  end
end
