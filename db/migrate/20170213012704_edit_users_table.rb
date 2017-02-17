class EditUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :province, :string
    add_column :users, :country, :string
  end
end
