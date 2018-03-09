class AddColumnToScorecardsInterviewKitId < ActiveRecord::Migration
  def change
    add_column :scorecards, :interview_kit_template_id, :integer
    add_column :scorecards, :assessment_id, :integer
  end
end
