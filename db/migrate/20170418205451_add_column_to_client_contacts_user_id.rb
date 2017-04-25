class AddColumnToClientContactsUserId < ActiveRecord::Migration
  def change
    add_column :client_contacts, :user_id, :integer
    add_column :client_contacts, :phone, :string
  end
end
