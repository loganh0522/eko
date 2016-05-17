class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.string :name
      t.integer :job_education_levels
    end
  end
end
