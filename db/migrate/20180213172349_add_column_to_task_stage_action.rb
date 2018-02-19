class AddColumnToTaskStageAction < ActiveRecord::Migration
  def change
    add_column :tasks, :stage_action_id, :integer
    add_column :messages, :stage_action_id, :integer
  end
end
