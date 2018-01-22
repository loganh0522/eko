class AddColumnToExperienceUserSkillString < ActiveRecord::Migration
  def change
    add_column :work_experiences, :skill, :string
  end
end
