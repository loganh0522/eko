class User < ActiveRecord::Base
  # include Elasticsearch::Model 
  # include Elasticsearch::Model::Callbacks 
  # index_name ["talentwiz", Rails.env].join('_') 
  #Business User Relationships

  validates_presence_of :first_name, :last_name, :email, :password, :on => [ :create ]
  validates_presence_of :first_name, :last_name, :email, :on => [ :update ]
  validates_uniqueness_of :email, :on => [ :create, :update ]

  validates_presence_of :password, :confirmation, :on => [:update_password]
  before_create :downcase_email
  after_save :set_full_name

  liquid_methods :first_name, :last_name, :full_name
  
  belongs_to :company

  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams 
  
  has_many :assigned_users
  has_many :tasks, through: :assigned_users, source: :assignable, source_type: "Task"
  has_many :interviews, through: :assigned_users, source: :assignable, source_type: "Interview"
  has_many :interview_invitations, through: :assigned_users, source: :assignable, source_type: "InterviewInvitation"
  has_many :orders
  has_many :event_ids
  
  has_many :application_scorecards
  has_many :invitations
  has_many :messages
  has_many :activities
  has_many :notifications
  has_many :ratings
  has_one  :email_signature

  has_many :mentions
  has_many :mentioned, :through => :mentions
  has_many :mentioned, :class_name => "Mention", :foreign_key => "mentioned_id"
  has_many :email_templates

  has_secure_password 

  # Job Seeker User relationships 
  
  has_one :profile
  has_many :candidates
  has_many :applications
  has_one :user_avatar

  has_one :google_token
  has_one :outlook_token
  has_many :social_links
  validates_presence_of :first_name, :last_name, :email
  validates_associated :social_links
  
  accepts_nested_attributes_for :social_links, 
    allow_destroy: true

  #Carrierwave uploader and minimagic for User Profile Pictures
  searchkick word_start: [:full_name]

  def search_data
    attributes.merge(
      full_name: full_name
    )
  end

  def all_tasks
    self.tasks
  end

  def access_token
    if self.outlook_token.present?
      access_token = self.outlook_token.access_token
    else
      access_token = self.google_token.access_token
    end
    return access_token
  end
  
  def open_tasks
    self.tasks.where(status: 'active')
  end

  def complete_tasks
    self.tasks.where(status: 'complete')
  end
  
  def role_symbols
    if role == "Admin" 
      [:admin] 
    elsif role == "Hiring Manager"
      [:hiring_manager]
    elsif role == "Recruiter"
      [:recruiter] 
    end
  end

  def as_indexed_json(options={})
    as_json(
      only: [:first_name, :last_name, :tag_line],
      include: {
        work_experiences: {only: [:title, :description, :company_name]}, 
        applications: {only: [:created_at, :user_id, :job_id]}        
        }        
      )
  end

  def downcase_email
    self.email = self.email.downcase
  end

  def set_full_name
    self.full_name = "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  def current_jobs
    @current_jobs = self.profile.work_experiences.where(current_position: true)
    return @current_jobs
  end
end