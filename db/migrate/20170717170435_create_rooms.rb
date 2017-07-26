class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :company_id 
      t.string :email
      t.string :name
      t.timestamps
    end
  end
end
