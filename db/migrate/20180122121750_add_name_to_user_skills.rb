class AddNameToUserSkills < ActiveRecord::Migration
  def change
    add_column :user_skills, :name, :string
  end
end
