class AddColumnToTasksCreatedBy < ActiveRecord::Migration
  def change
    add_column :tasks, :created_by, :integer
    add_column :tasks, :updated_by, :integer
  end
end
