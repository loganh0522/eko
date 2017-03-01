class User < ActiveRecord::Base
  # include Elasticsearch::Model 
  # include Elasticsearch::Model::Callbacks 
  # index_name ["talentwiz", Rails.env].join('_') 

  #Business User Relationships
  liquid_methods :first_name, :last_name, :full_name
  
  belongs_to :company

  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams 
  has_many :application_scorecards
  has_many :invitations
  has_many :messages
  has_many :activities
  has_many :notifications
  has_many :ratings

  has_many :interviews
  has_many :interviews, through: :my_interviews
  has_many :mentions
  has_many :mentioned, :through => :mentions
  has_many :mentioned, :class_name => "Mention", :foreign_key => "mentioned_id"
  has_many :email_templates

  validates_presence_of :first_name, :last_name, :email, :password, on: [:create]
  validates_uniqueness_of :email

  has_secure_password validations: false 

  # Job Seeker User relationships 
  
  has_one :profile
  
  has_many :applications
  has_many :apps, through: :applications, class_name: "Job", foreign_key: :job_id

  has_one :user_avatar

  has_one :google_token
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

  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
  end

  def current_jobs
    @current_jobs = self.work_experiences.where(current_position: true)
    return @current_jobs
  end
end