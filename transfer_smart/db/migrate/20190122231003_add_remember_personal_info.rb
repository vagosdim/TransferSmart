class AddRememberPersonalInfo < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :remember_personal_info, :bool
  end
end
