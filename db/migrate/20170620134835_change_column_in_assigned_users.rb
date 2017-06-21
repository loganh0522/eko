class ChangeColumnInAssignedUsers < ActiveRecord::Migration
  def change
    remove_column :assigned_users, :assignable_type
    add_column :assigned_users, :assignable_type, :string
  end
end
