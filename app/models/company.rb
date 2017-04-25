class Company < ActiveRecord::Base
  before_create :generate_token

  has_many :users
  has_many :invitations
  
  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id
  
  has_many :jobs
  has_many :subsidiaries
  has_many :locations
  has_one :customer
  has_one :job_board
  has_many :clients
  has_many :payments
  has_many :activities, -> {order("created_at DESC")}
  has_many :tags
  has_many :email_templates
  validates_presence_of :name, :website

  liquid_methods :name

  def deactivate!
    update_column(:active, false)
  end

  def generate_token
    self.widget_key = SecureRandom.urlsafe_base64
  end

  def company_locations
    @locations = []
    self.jobs.each do |job|  
      @locations.append(job.location) unless @locations.include?(job.location)
    end
    return @locations
  end

  def company_jobs
    @jobs = []  
    self.jobs.each do |job|  
      @jobs.append(job.title) unless @jobs.include?(job.title)
    end
    return @jobs
  end
end