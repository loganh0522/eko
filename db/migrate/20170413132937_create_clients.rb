class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :company_name
      t.string :address 
      t.string :website
      t.string :phone
      t.timestamps
    end
  end
end
