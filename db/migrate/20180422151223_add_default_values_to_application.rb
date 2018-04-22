class AddDefaultValuesToApplication < ActiveRecord::Migration
  def change
    change_column :applications, :rejected, :boolean, default: false
    change_column :applications, :reviewed, :boolean, default: false
    change_column :applications, :hired, :boolean, default: false
  end
end
