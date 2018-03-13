class RemoveColumnFromStageActionKitId < ActiveRecord::Migration
  def change
    remove_column :stage_actions, :interview_kit_template_id
  end
end
