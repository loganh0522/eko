class AddTimestampsToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :created_at, :datetime
    add_column :applications, :updated_at, :datetime
  end
end
