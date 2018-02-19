class CreateInterviewKit < ActiveRecord::Migration
  def change
    create_table :interview_kits do |t|
      t.integer :application_id
      t.integer :candidate_id
      t.integer :stage_id
      t.integer :interview_id
      t.integer :rating
      t.text :concerns
      t.text :body
      t.text :preperation
    end
  end
end
