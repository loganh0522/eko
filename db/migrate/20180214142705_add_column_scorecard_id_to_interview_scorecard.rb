class AddColumnScorecardIdToInterviewScorecard < ActiveRecord::Migration
  def change
    add_column :interview_scorecards, :scorecard_id, :integer
    add_column :interview_scorecards, :stage_action_id, :integer
    add_column :interview_scorecards, :concerns, :text
    remove_column :interview_scorecards, :stage_action
  end
end
