class AddColumnToPermissionsAddDefaultTrueToField < ActiveRecord::Migration
  def change
    change_column :permissions, :send_event_invitation, :boolean, default: true
  end
end
