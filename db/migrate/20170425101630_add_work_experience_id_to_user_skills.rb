class AddWorkExperienceIdToUserSkills < ActiveRecord::Migration
  def change
    add_column :user_skills, :work_experience_id, :integer
  end
end
