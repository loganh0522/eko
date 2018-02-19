class AddColumnToQuestionsInterviewKitId < ActiveRecord::Migration
  def change
    add_column :questions, :interview_kit_id, :integer
    add_column :scorecards, :interview_kit_id, :integer
    add_column :scorecards, :interview_id, :integer
    add_column :scorecards, :comments, :text
    add_column :scorecards, :concerns, :text
  end
end
