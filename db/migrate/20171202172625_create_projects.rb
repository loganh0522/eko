class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.integer :work_experience_id
      t.integer :education_id
      t.string :title
      t.text :description
      t.text :problem
      t.text :solution
      t.text :role
    end
  end
end
