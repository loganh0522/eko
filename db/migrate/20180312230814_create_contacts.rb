class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :location
      t.integer :client_id
      t.integer :company_id
      t.integer :association_id
      t.timestamps
    end
  end
end
