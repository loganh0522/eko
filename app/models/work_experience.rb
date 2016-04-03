class WorkExperience < ActiveRecord::Base
  belongs_to :user
  
  has_many :job_industries
  has_many :industries, through: :job_industries

  has_many :job_functions
  has_many :functions, through: :job_functions

  validates_presence_of :title, :company_name, :description
end 