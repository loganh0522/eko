class AddColumnToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :company_id, :integer
  end
end
