class Job < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 
  
  liquid_methods :title
  belongs_to :company
  belongs_to :job

  has_one :questionairre
  has_one :scorecard
  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  has_many :stages, -> {order(:position)}
  has_many :interviews
  has_many :activities, -> {order("created_at DESC")}


  has_many :job_industries
  has_many :industries, through: :job_industries

  has_many :job_functions
  has_many :functions, through: :job_functions
  
  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id
  
  validates_presence_of :title, :description, :location, :address, 
    :education_level, :kind, :career_level

  def self.search(search)

  end

  def as_indexed_json(options={})
    as_json(
      only: [:title, :description, :status, :city, :country, :province,
        :education_level, :career_level, :kind, :created_at, :updated_at, 
        :start_salary, :end_salary]
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