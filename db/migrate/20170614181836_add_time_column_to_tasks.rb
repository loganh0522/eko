class AddTimeColumnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :due_time, :string
  end
end
