class UserSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :work_experience
  belongs_to :project
  before_create :add_user
  
  def add_user
    if self.work_experience.present? 
      self.user_id = self.work_experience.user.id
    else 
      self.user_id = self.project.user.id
    end
  end
end