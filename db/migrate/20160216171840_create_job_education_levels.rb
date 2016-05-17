class CreateJobEducationLevels < ActiveRecord::Migration
  def change
    create_table :job_education_levels do |t|
      t.integer :education_level_id
    end
  end
end
