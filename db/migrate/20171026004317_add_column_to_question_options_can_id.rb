class AddColumnToQuestionOptionsCanId < ActiveRecord::Migration
  def change
    add_column :question_answers, :candidate_id, :integer
    add_column :question_answers, :job_id, :integer
  end
end
