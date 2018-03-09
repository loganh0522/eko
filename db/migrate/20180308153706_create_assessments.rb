class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :application_id
      t.integer :candidate_id
      t.integer :interview_id
      t.integer :interview_kit_id
      t.string :name
      t.timestamps
    end

    add_column :interview_scorecards, :assessment_id, :integer
    add_column :application_scorecards, :assessment_id, :integer
  end
end
