class User < ActiveRecord::Base
  belongs_to :company

  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams

  has_many :invitations

  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email

  has_secure_password validations: false 

  # Job Seeker User relationships 
  has_many :applications
  has_many :jobs, through: :applications
  
  has_many :work_experiences
end