class CreateJobExperienceLevels < ActiveRecord::Migration
  def change
    create_table :job_experience_levels do |t|
      t.integer :job_id, :experience_level_id
    end
  end
end
