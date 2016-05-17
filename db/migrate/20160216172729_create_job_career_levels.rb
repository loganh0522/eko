class CreateJobCareerLevels < ActiveRecord::Migration
  def change
    create_table :job_career_levels do |t|
      t.integer :career_level_id
    end
  end
end
