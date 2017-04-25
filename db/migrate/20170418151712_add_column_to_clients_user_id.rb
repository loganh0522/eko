class AddColumnToClientsUserId < ActiveRecord::Migration
  def change
    add_column :clients, :user_id, :integer
    add_column :clients, :num_employees, :integer
    add_column :clients, :status, :string
  end
end
