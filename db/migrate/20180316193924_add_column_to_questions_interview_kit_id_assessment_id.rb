class AddColumnToQuestionsInterviewKitIdAssessmentId < ActiveRecord::Migration
  def change
    add_column :questions, :assessment_id, :integer
    add_column :questions, :interview_kit_template_id, :integer
  end
end
