class AddColumnToStageActionIsScheduled < ActiveRecord::Migration
  def change
    add_column :stage_actions, :is_scheduled, :boolean, default: false 
    add_column :stage_actions, :sent_request, :boolean, default: false 
    add_column :stage_actions, :is_complete, :boolean, default: false 
    add_column :interviews, :stage_action_id, :integer
    add_column :interviews, :stage_id, :integer
  end
end
