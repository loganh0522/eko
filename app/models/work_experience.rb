class WorkExperience < ActiveRecord::Base
  belongs_to :user
  
  has_many :exp_industries
  has_many :industries, through: :exp_industries

  has_many :exp_functions
  has_many :functions, through: :exp_functions

  has_many :job_countries
  has_many :countries, through: :job_countries

  has_many :job_states
  has_many :states, through: :job_states

  has_many :accomplishments


  validates_presence_of :title, :company_name, :description
end 