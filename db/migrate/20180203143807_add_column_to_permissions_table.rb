class AddColumnToPermissionsTable < ActiveRecord::Migration
  def change
    add_column :permissions, :advertise_job, :boolean, default: true
  end
end
