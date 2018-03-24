class ChangeTableNameToScorecardAnswersToCompletedAssessments < ActiveRecord::Migration
  def change
    rename_table :scorecard_answers, :completed_assessments
    add_column :scorecard_ratings, :question_id, :integer
    add_column :scorecard_ratings, :answerable, :string
    add_column :scorecard_ratings, :answerable_id, :integer
    add_column :scorecard_ratings, :completed_assessment_id, :integer
    add_column :scorecard_ratings, :file, :string
    rename_table :scorecard_ratings, :answers
  end
end
