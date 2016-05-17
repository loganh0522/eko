class CreateCareerLevels < ActiveRecord::Migration
  def change
    create_table :career_levels do |t|
      t.string :name
      t.integer :job_career_levels
    end
  end
end
