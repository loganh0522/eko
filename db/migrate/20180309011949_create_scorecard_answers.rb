class CreateScorecardAnswers < ActiveRecord::Migration
  def change
    create_table :scorecard_answers do |t|
      t.integer :user_id
      t.integer :assessment_id
      t.integer :stage_action_id
      t.integer :scorecard_id
      t.integer :interview_id
      t.integer :candidate_id
      t.integer :application_id

      t.integer :overall
      t.text :feedback
      t.text :candidate_feedback
      t.text :concerns

      t.timestamps
    end

    add_column :assessments, :job_id, :integer
  end
end
