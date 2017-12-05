class AddColumnToMediaPhotosAndUserSkillsTags < ActiveRecord::Migration
  def change
    add_column :user_skills, :project_id, :integer
    add_column :tags, :project_id, :integer
  end
end
