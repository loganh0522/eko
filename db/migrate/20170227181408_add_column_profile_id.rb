class AddColumnProfileId < ActiveRecord::Migration
  def change
    add_column :work_experiences, :profile_id, :integer
    add_column :user_certifications, :profile_id, :integer
    add_column :educations, :profile_id, :integer
    add_column :user_skills, :profile_id, :integer
  end
end
