class AddColumnToInvitationsPermissionId < ActiveRecord::Migration
  def change
    add_column :invitations, :permission_id, :integer
  end
end
