class Skill < ActiveRecord::Base 
  has_many :user_skills
  has_many :users, through: :user_skills

  validates_presence_of :name

  def self.find_or_create_skill(name)
    @name = name.titleize
    self.where(name: @name).first_or_create
  end
end