class Job < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 
  
  # after_commit on: [:update] do
  #   __elasticsearch__.update_document 
  # end

  liquid_methods :title
  belongs_to :company
  
  has_one :questionairre
  has_one :scorecard

  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  
  has_many :stages, -> {order(:position)}
  has_many :interviews
  has_many :interview_invitations
  
  has_many :activities, -> {order("created_at DESC")}
  has_many :applications
  has_many :candidates, through: :applications

  has_many :tasks, as: :taskable, :dependent => :destroy
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy 

  has_many :job_industries
  has_many :industries, through: :job_industries

  has_many :job_functions
  has_many :functions, through: :job_functions
  
  
  validates_presence_of :title, :description, :location, :address, 
    :education_level, :kind, :career_level
  
  ########## Actions Taken After create ############ 

  after_validation :set_token, :convert_location, :job_url
  after_save :create_job_actions, :set_token, :create_stages 
  
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

  def create_job_actions
    Questionairre.create(job: self)
    Scorecard.create(job: self)
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
    @tasks = []
    self.tasks.where(status: 'complete').each do |task|
      @tasks.append(task) unless @tasks.include?(task)
    end
    self.applications.each do |application|
      application.complete_tasks.each do |task|
        @tasks.append(task) unless @tasks.include?(task)
      end
    end
    return @tasks
  end

   def open_tasks
    @tasks = []
    self.tasks.where(status: 'active').each do |task|
      @tasks.append(task) unless @tasks.include?(task)
    end
    
    self.applications.each do |application|
      application.open_tasks.each do |task|
        @tasks.append(task) unless @tasks.include?(task)
      end
    end
    return @tasks
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

  def self.search(search)

  end

  def as_indexed_json(options={})
    as_json(
      only: [:id, :title, :description, :status, :city, :country, :province,
        :education_level, :career_level, :kind, :created_at, :updated_at, 
        :start_salary, :end_salary, :location]
    )
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["title", "status"]
        }
      }
    }

    __elasticsearch__.search(search_definition)
  end
end