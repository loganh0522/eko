class UserSkill < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill
  belongs_to :profile

  validates_uniqueness_of :skill, :message => "You already have this skill listed." 
end