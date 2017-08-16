class AddColumnToQuestions2 < ActiveRecord::Migration
  def change
    remove_column :questions, :questionairre_id
    add_column :questions, :job_id, :integer
  end
end
