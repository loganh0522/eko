class AddColumnToAnswersQuestionOptionId < ActiveRecord::Migration
  def change
    add_column :answers, :question_option_id, :integer
  end
end
