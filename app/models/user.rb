class User < ActiveRecord::Base
  belongs_to :company

  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams
  has_many :application_scorecards
  has_many :invitations
  has_many :messages

  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email

  has_secure_password validations: false 

  # Job Seeker User relationships 
  
  has_many :applications
  has_many :apps, through: :applications, class_name: "Job", foreign_key: :job_id
  has_many :educations

  has_many :work_experiences
end