class AddColumnOnStageActionStandardStage < ActiveRecord::Migration
  def change
    add_column :stage_actions, :standard_stage, :string
    add_column :stage_actions, :job_id, :integer
  end
end
