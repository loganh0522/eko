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

  def self.search(search)

  end

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