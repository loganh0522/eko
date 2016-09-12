class User < ActiveRecord::Base
  include Elasticsearch::Model 
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 

  #Business User Relationships

  belongs_to :company
  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams
  has_many :application_scorecards
  has_many :invitations
  has_many :messages
  has_many :activities

  validates_presence_of :first_name, :last_name, :email, :password, on: [:create]
  validates_uniqueness_of :email

  has_secure_password validations: false 

  # Job Seeker User relationships 
  
  has_many :applications
  has_many :apps, through: :applications, class_name: "Job", foreign_key: :job_id
  has_many :educations

  has_many :work_experiences, -> {order("end_year DESC")} 
  has_one :user_avatar

  has_many :job_countries
  has_many :countries, through: :job_countries

  has_many :job_states
  has_many :states, through: :job_states

  has_many :user_skills
  has_many :skills, through: :user_skills

  has_many :user_certifications
  has_many :certifications, through: :user_certifications

  #Carrierwave uploader and minimagic for User Profile Pictures

  def as_indexed_json(options={})
    as_json(
      only: [:first_name, :last_name, :tag_line],
      include: {
        work_experiences: {only: [:title, :description, :company_name]}, 
        applications: {only: [:created_at, :user_id, :job_id]}        
        }        
      )
  end

  def sort_by_date
    
  end
end