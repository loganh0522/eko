class AddColumnToApplicationHired < ActiveRecord::Migration
  def change
    add_column :applications, :hired, :boolean, default: false
  end
end
