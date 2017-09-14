class AddColumnCompletedByToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed_by_id, :integer, foreign_key: true, index: true
  end
end
