class CreateClientContacts < ActiveRecord::Migration
  def change
    create_table :client_contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :email
      t.integer :client_id
      t.timestamps
    end
  end
end
