class AddColumnTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kind, :string
    add_column :users, :role, :string
  end
end
