class CreateQuestionairres < ActiveRecord::Migration
  def change
    create_table :questionairres do |t|
      t.integer :job_id
      t.integer :application_id
    end
  end
end
