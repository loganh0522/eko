class Skill < ActiveRecord::Base 
  has_many :user_skills
  has_many :users, through: :user_skills

  def self.find_or_create_skill(name)
    name.capitalize
    self.where(name: name).first_or_create
  end
end