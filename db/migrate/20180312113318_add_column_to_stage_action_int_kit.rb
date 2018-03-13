class AddColumnToStageActionIntKit < ActiveRecord::Migration
  def change
    add_column :stage_actions, :interview_kit_template_id, :integer
  end
end
