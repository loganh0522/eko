class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password, :on => [ :create ]
  validates_presence_of :first_name, :last_name, :email, :on => [ :update ]
  validates_uniqueness_of :email, :on => [ :create, :update ]
  validates_presence_of :password, :confirmation, :on => [:update_password]

  before_create :downcase_email, :set_full_name
  after_save :set_full_name
  before_update :set_full_name
  after_create :create_email_signature, if: :business_user
  liquid_methods :first_name, :last_name, :full_name
  
  belongs_to :company
  # has_many :company_users
  # has_many :companies, through: :company_users

  has_many :hiring_teams
  has_many :jobs, through: :hiring_teams 
  has_many :assigned_users
  has_many :tasks, through: :assigned_users, source: :assignable, source_type: "Task"
  has_many :interviews, through: :assigned_users, source: :assignable, source_type: "Interview"
  has_many :interview_invitations, through: :assigned_users, source: :assignable, source_type: "InterviewInvitation"
  has_many :interview_scorecards
  
  has_many :orders
  has_many :event_ids
  belongs_to :permission
  has_many :stage_actions


  has_many :completed_assessments
  
  has_many :invitations
  has_many :messages
  has_many :activities
  has_many :notifications
  has_many :answers
  has_many :ratings
  has_one  :email_signature

  has_many :mentions
  has_many :mentioned, :through => :mentions
  has_many :mentioned, :class_name => "Mention", :foreign_key => "mentioned_id"
  
  has_many :email_templates
  has_one :google_token
  has_one :outlook_token
  has_secure_password 

  # Job Seeker User relationships 
  
  has_one :profile
  has_many :candidates
  has_many :applications
  
  has_one :user_avatar
  has_one :background_image
  
  has_many :work_experiences, -> {order("end_year DESC")} 
  has_many :educations
  has_many :user_certifications
  has_many :social_links
  has_many :user_skills
  has_many :skills, through: :user_skills
  has_many :projects

  validates_associated :social_links
  validates_associated :work_experiences
  validates_associated :educations
  validates_associated :user_certifications
  
  accepts_nested_attributes_for :work_experiences, 
    allow_destroy: true
    # reject_if: :experience_validation

  accepts_nested_attributes_for :educations, 
    allow_destroy: true
    # reject_if: proc { |a| a[:body].blank? }

  accepts_nested_attributes_for :user_certifications, 
    allow_destroy: true
    # reject_if: proc { |a| a[:body].blank? }

  accepts_nested_attributes_for :social_links, 
    allow_destroy: true

  def business_user
    self.kind == 'business'
  end

  # def convert_location
  #   location = params[:user][:location].split(',')
  #   if location.count == 3
  #     @user.update_column(:city, location[0])
  #     @user.update_column(:province, location[1])
  #     @user.update_column(:country, location[2])
  #   else
  #     @user.update_column(:city, location[0])
  #     @user.update_column(:country, location[1])
  #   end
  # end
  
  #Carrierwave uploader and minimagic for User Profile Pictures
  searchkick word_start: [:full_name]

  def search_data
    attributes.merge(
      full_name: full_name,
      work_titles: work_experiences.map(&:title),
      work_description: work_experiences.map(&:description),
      work_company: work_experiences.map(&:company_name),
      education_degree: educations.map(&:degree),
      education_description: educations.map(&:description),
      education_school: educations.map(&:school)
    )
  end

  def access_token
    if self.outlook_token.present?
      access_token = self.outlook_token.access_token
    else
      access_token = self.google_token.access_token
    end
    return access_token
  end
  
  def create_email_signature
    EmailSignature.create(user_id: self.id, signature: "#{self.first_name} #{self.last_name}")  
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

  def is_admin? 
    self.role == "Admin"
  end

  def avatar_url
    if self.user_avatar.present?
      self.user_avatar.image.small_image.url 
    else
      return "undefined"
    end
  end

  def downcase_email
    self.email = self.email.downcase
  end

  def set_full_name
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.capitalize
    self.full_name = "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  def scorecard(assessment)
    ScorecardAnswer.where(user: self, assessment_id: assessment.id).first 
  end

  def current_jobs
    @current_jobs = self.profile.work_experiences.where(current_position: true)
    return @current_jobs
  end
  
  def organize_work_experiences
    self.work_experiences.sort_by{|work| [work.start_year, work.end_year] }.reverse
  end

  def current_position
    self.work_experiences.where(current_position: 1).first
  end
end