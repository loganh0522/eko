class CreateJobTemplates < ActiveRecord::Migration
  def change
    create_table :job_templates do |t|
      t.integer :company_id 
      t.integer :department_id
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :start_salary
      t.string :end_salary

      t.timestamps
    end
  end
end
