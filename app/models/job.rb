class Job < ActiveRecord::Base
  liquid_methods :title
  belongs_to :company
  belongs_to :client

  has_many :questions, :dependent => :destroy
  has_one :scorecard, :dependent => :destroy
  has_one :job_feed
  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  
  has_many :stages, -> {order(:position)}, :dependent => :destroy
  has_many :stage_actions, :dependent => :destroy
  has_many :interviews, :dependent => :destroy
  has_many :interview_invitations, :dependent => :destroy
  has_many :activities, -> {order("created_at DESC")}, :dependent => :destroy
  has_many :applications, :dependent => :destroy
  has_many :candidates, through: :applications
  has_many :tasks
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy 

  has_many :orders
  has_many :order_items
  
  validates_presence_of :title, :description, :location
    
  # :education_level, :kind, :career_level
  
  ########## Actions Taken After create ############ 

  after_validation :set_token, :convert_location, :job_url
  after_create :create_stages, :set_token, :create_job_feed
  
  searchkick word_start: [:title]

  def create_stages
    @stages = self.company.default_stages
    @position = 1 
    @stages.each do |stage| 
      Stage.create(name: stage.name, position: @position, job: self)
      @position += 1
    end
  end

  def job_url
    self.url = "#{self.company.job_board.subdomain}.talentwiz.ca/jobs/#{self.id}" 
  end

  def set_token
    self.token = SecureRandom.hex(5)
  end

  def create_job_feed
    JobFeed.create(job_id: self.id)
  end

  def convert_location
    location = self.location.split(',')
    if location.count == 3
      self.city = location[0] 
      self.province = location[1]
      self.country = location[2]
    else
      self.city = location[0] 
      self.country = location[1]
    end
  end

  ########## Job Tasks Actions ##############
  
  def all_tasks
    @tasks = []
    self.tasks.each do |task|
      @tasks.append(task) unless @tasks.include?(task)
    end
    self.applications.each do |application|
      application.tasks.each do |task|
        @tasks.append(task) unless @tasks.include?(task)
      end
    end
    return @tasks
  end

  def complete_tasks
    self.tasks.where(status: 'complete')
  end

  def open_tasks
    Task.where(job_id: self.id, status: 'active')
  end


  ############ Job Applications #################

  def tags_present(applications)
    @tags = []
    applications.each do |application|
      if application.candidate.tags.present?
        applicant.candidate.tags.each do |tag| 
          @tags.append(tag) unless @tags.include?(tag)
        end
      end
    end
  end

  ################ Job Search Details ###################

  def search_data
    attributes.merge(
      users: users.map(&:id),
      candidates: candidates.map(&:id)
    )
  end
end