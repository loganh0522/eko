class UserSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :work_experience

  validates_uniqueness_of :skill, :message => "You already have this skill listed." 
end