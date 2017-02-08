class Job < ActiveRecord::Base
  liquid_methods :title
  belongs_to :company

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
  
  validates_presence_of :title, :description, :location, :address, :industry_ids, :function_ids, 
  :education_level, :kind, :career_level
end