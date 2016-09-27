class AddColumnRejectedToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :rejected, :boolean
  end
end
