class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :work_experience
  belongs_to :education
  has_many :attachments, :dependent => :destroy 
  has_many :user_skills

  validates_presence_of :title, :description

  accepts_nested_attributes_for :attachments, 
    allow_destroy: true
end