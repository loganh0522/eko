class CreateInterviewScorecard < ActiveRecord::Migration
  def change
    create_table :interview_scorecards do |t|
      t.integer :interview_id
      t.integer :interview_kit_id
      t.integer :candidate_id
      t.integer :stage_action
      t.integer :application_id
      t.integer :user_id
      t.text :feedback
      t.integer :overall
    end

    add_column :question_answers, :user_id, :integer
    add_column :question_answers, :interview_kit_id, :integer
    add_column :scorecard_ratings, :interview_scorecard_id, :integer
  end
end
