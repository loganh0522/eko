class CreateWorkExperience < ActiveRecord::Migration
  def change
    create_table :work_experiences do |t|
      t.string :title, :company_name, :start_date, :end_date 
      t.text :description
      t.integer :current_position
      t.integer :user_id
      t.timestamps
    end
  end
end
