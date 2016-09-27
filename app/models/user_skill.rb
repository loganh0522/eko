class UserSkill < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  validates_uniqueness_of :skill, :message => "You already have this skill listed." 
end