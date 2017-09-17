class Company < ActiveRecord::Base
  before_create :generate_token
  has_many :users
  has_many :invitations
  has_many :rejection_reasons
  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id
  has_many :candidates
  has_many :tasks
  has_many :jobs
  has_many :interviews
  has_many :interview_invitations
  has_many :rooms
  has_many :conversations  
  has_one :customer
  has_one :job_board
  has_many :clients
  has_many :orders
  has_many :payments
  has_many :activities, -> {order("created_at DESC")}
  has_many :tags
  has_many :email_templates
  has_many :default_stages
  has_one :application_email
  has_many :tasks, as: :taskable, :dependent => :destroy
  has_many :tasks
  has_many :subsidiaries
  has_many :locations
  
  validates_presence_of :name, :website

  liquid_methods :name

  after_create :create_rejection_reasons, :create_default_stages
  
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