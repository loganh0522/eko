class UserSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :work_experience
  belongs_to :project
end