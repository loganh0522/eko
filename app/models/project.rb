class Project < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :work_experience
  belongs_to :education
  has_many :attachments, :dependent => :destroy 
  
  has_many :user_skills, :dependent => :destroy
  has_many :skills, through: :user_skills

  validates_presence_of :title, :description

  accepts_nested_attributes_for :attachments, 
    allow_destroy: true

  accepts_nested_attributes_for :user_skills, 
    allow_destroy: true
end