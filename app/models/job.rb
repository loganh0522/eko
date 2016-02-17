class Job < ActiveRecord::Base
  belongs_to :company

  has_one :questionairre
  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  has_many :stages, -> {order(:position)}

  has_many :job_industries
  has_many :industries, through: :job_industries

  has_many :job_functions
  has_many :functions, through: :job_functions

  has_many :job_type
  has_many :job_kind, through: :job_type

  has_many :job_education_level
  has_many :education_level, through: :job_education_level

  has_many :job_career_level
  has_many :career_level, through: :job_career_level
  
  
  validates_presence_of :title, :benefits, :description, :country, :city, :province

  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id

end