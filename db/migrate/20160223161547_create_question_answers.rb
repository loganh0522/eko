class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.text :body
      t.integer :question_id, :application_id, :question_option_id
    end
  end
end
