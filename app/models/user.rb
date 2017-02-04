class User < ActiveRecord::Base
  # include Elasticsearch::Model 
  # include Elasticsearch::Model::Callbacks 
  # index_name ["talentwiz", Rails.env].join('_') 

  #Business User Relationships
  liquid_methods :first_name, :last_name
  
  belongs_to :company

  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams 
  has_many :application_scorecards
  has_many :invitations
  has_many :messages
  has_many :activities
  has_many :notifications

  has_many :interviews
  has_many :interviews, through: :my_interviews

  has_many :mentions
  has_many :mentioned, :through => :mentions
  has_many :mentioned, :class_name => "Mention", :foreign_key => "mentioned_id"


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

  has_one :google_token
  #Carrierwave uploader and minimagic for User Profile Pictures

  accepts_nested_attributes_for :work_experiences, allow_destroy: true, reject_if: proc { |a| a[:body].blank? }
  accepts_nested_attributes_for :educations, allow_destroy: true, reject_if: proc { |a| a[:body].blank? }

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

  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
  end

  def current_jobs
    @current_jobs = self.work_experiences.where(current_position: true)
    return @current_jobs
  end
end