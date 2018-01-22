class AddColumnToJobActive < ActiveRecord::Migration
  def change
    add_column :jobs, :is_active, :boolean
  end
end
