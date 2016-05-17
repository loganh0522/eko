class CreateExperienceLevels < ActiveRecord::Migration
  def change
    create_table :experience_levels do |t|
      t.text :name 
      t.integer :job_id
    end
  end
end
