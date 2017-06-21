class AddColumnUserRoleStatus < ActiveRecord::Migration
  def change
    add_column :invitations, :user_role, :string
    add_column :invitations, :status, :string
  end
end
