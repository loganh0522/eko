class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.text :body
      t.integer :question_id
    end
  end
end
