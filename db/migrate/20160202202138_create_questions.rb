class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :body, :kind
      t.integer :questionairre_id, :required
    end
  end
end
