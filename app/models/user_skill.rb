class UserSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :work_experience
  belongs_to :project

  validates_presence_of :skill_id
  validates_uniqueness_of :skill, :message => "You already have this skill listed." 
end