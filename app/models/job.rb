class Job < ActiveRecord::Base
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks 
  # index_name ["talentwiz", Rails.env].join('_') 
  
  # # after_commit on: [:update] do
  # #   __elasticsearch__.update_document 
  # # end

  liquid_methods :title
  
  belongs_to :company
  has_many :questions, :dependent => :destroy
  has_one :scorecard, :dependent => :destroy
  has_one :job_feed
  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  
  has_many :stages, -> {order(:position)}, :dependent => :destroy
  has_many :interviews, :dependent => :destroy
  has_many :interview_invitations, :dependent => :destroy
  
  has_many :activities, -> {order("created_at DESC")}, :dependent => :destroy
  has_many :applications, :dependent => :destroy
  has_many :candidates, through: :applications

  has_many :tasks, as: :taskable, :dependent => :destroy
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy 

  has_many :job_industries, :dependent => :destroy
  has_many :industries, through: :job_industries

  has_many :job_functions, :dependent => :destroy
  has_many :functions, through: :job_functions
  
  
  validates_presence_of :title, :description, :location, :address, 
    :education_level, :kind, :career_level
  
  ########## Actions Taken After create ############ 

  after_validation :set_token, :convert_location, :job_url
  after_create :create_stages, :set_token, :create_job_feed
  
  searchkick word_start: [:title], callbacks: :async

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

  def search_data
    attributes.merge(
      users: users.map(&:id),
      candidates: candidates.map(&:id)
    )
  end


  # mapping _parent: { type: 'company'}, _routing: {type: 'company', required: true } do
  #   indexes :company_id, type: 'integer'
  #   indexes :title, type: 'string'
  #   indexes :description, type: 'string'
  #   indexes :status, type: 'string'
  #   indexes :city, type: 'boolean'
  #   indexes :country, type: "string"
  #   indexes :location, type: "integer"
  #   indexes :created_at, type: "date"
  #   indexes :update_at, type: "date"
  # end

  # after_commit lambda { __elasticsearch__.index_document(parent: company_id, routing: company_id) }, on: :create
  # after_commit lambda { __elasticsearch__.update_document(parent: company_id, routing: company_id) }, on: :update
  # after_commit lambda { __elasticsearch__.delete_document(parent: company_id, routing: company_id) }, on: :destroy

  # def as_indexed_json(options={})
  #   as_json(
  #     only: [:id, :title, :description, :status, :city, :country, :province,
  #       :education_level, :career_level, :kind, :created_at, :updated_at, 
  #       :start_salary, :end_salary, :location, :company_id]
  #   )
  # end

  # def self.search(query, options={})
  #   search_definition = {
  #     query: {
  #       multi_match: {
  #         query: query,
  #         fields: ["title", "status"]
  #       }
  #     }
  #   }

  #   __elasticsearch__.search(search_definition)
  # end
end