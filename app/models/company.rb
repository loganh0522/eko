class Company < ActiveRecord::Base
  before_create :generate_token
  # has_many :company_users
  # has_many :users, through: :company_users
  
  has_many :users
  has_many :invitations, :dependent => :destroy
  has_many :rejection_reasons, :dependent => :destroy
  has_many :applications, :dependent => :destroy
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id
  has_many :candidates, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  has_many :interviews, :dependent => :destroy
  has_many :interview_invitations, :dependent => :destroy
  has_many :rooms, :dependent => :destroy
  has_many :conversations, :dependent => :destroy
  has_one :customer, :dependent => :destroy
  has_one :job_board, :dependent => :destroy
  has_many :clients, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  has_many :activities, -> {order("created_at DESC")}, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  has_many :email_templates, :dependent => :destroy
  has_many :default_stages, :dependent => :destroy
  has_one :application_email, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :job_templates, :dependent => :destroy
  has_many :subsidiaries, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :permissions, :dependent => :destroy
  has_one :background_image, :dependent => :destroy
  has_one :logo, :dependent => :destroy
  validates_presence_of :name, :website, :size, :location

  accepts_nested_attributes_for :users, 
    allow_destroy: true


  liquid_methods :name

  after_create :create_rejection_reasons, :create_default_stages, :create_application_email, :create_career_portal
  
  

  def deactivate!
    update_column(:active, false)
  end

  def generate_token
    self.widget_key = SecureRandom.urlsafe_base64
  end
  
  def create_default_stages
    stages = ["Screen", "Phone Interview", "Interview", 
      "Group Interview", "Offer", "Hired"]
    @position = 1 
    
    stages.each do |stage| 
      DefaultStage.create(name: stage, position: @position, company_id: self.id)
      @position += 1
    end
  end

  def create_rejection_reasons
    reasons = ["Under/Overqualified", "Unresponsive", "Timing", 
      "Offer Declined", "Position Closed", "Offer Declined", "Hired Elsewhere"]
    
    reasons.each do |reason| 
      RejectionReason.create(body: reason, company_id: self.id)
    end
  end

  def create_career_portal
    @subdomain = self.name.parameterize("")
    JobBoard.create(company_id: self.id, subdomain: @subdomain, kind: "advanced")
    create_job_board_header
  end  

  def create_job_board_header
    JobBoardHeader.create(header: "Come Work With Our Team",
      subheader: "We are hiring great people to help grow our company", job_board_id: self.job_board.id)
  end

  def create_application_email
    ApplicationEmail.create(body: "We appreciate your application for the {{job.title}}, we will be in touch with you soon.", subject: "Thanks for Applying to {{job.title}}", company_id: self.id)
  end

  def create_permissions
    Permission.create(company_id: d.id, name: "Hiring Manager",
      view_all_jobs: false, edit_career_portal: false, access_settings: false)

    Permission.create(company_id: d.id, name: "Recruiter",
      view_all_jobs: false, create_job: false, edit_job: false, advertise_job: false,
      add_team_members: false, assign_tasks: false, send_messages: false, view_all_messages: false,
      create_event: false, send_event_invitation: false, view_all_events: false,
      view_analytics: false, edit_career_portal: false, access_settings: false,
      edit_career_portal: false, access_settings: false)
  end

  ##### Task Methods #####

  def all_tasks
    self.tasks
  end

  def open_tasks
    self.tasks.where(status: 'active')
  end

  def complete_tasks
    self.tasks.where(status: 'complete')
  end

  def overdue_tasks
    self.tasks.where("due_date <= ?", Time.now)
  end

  def tasks_due_today
    self.tasks.where("due_date = ?", Time.now)
  end

  ### Company Locations ###

  def company_locations
    @locations = []
    self.jobs.each do |job|  
      @locations.append(job.location) unless @locations.include?(job.location)
    end
    return @locations
  end

  ### Job Methods ###
  def active_jobs
    self.jobs.where(is_active: true)
  end

  def open_jobs
    self.jobs.where(status: "open")
  end

  def closed_jobs
    self.jobs.where(status: "closed")
  end

  def company_jobs
    @jobs = []  
    self.jobs.each do |job|  
      @jobs.append(job.title) unless @jobs.include?(job.title)
    end
    return @jobs
  end

  def company_messages 
    self.candidates.messages
  end
end