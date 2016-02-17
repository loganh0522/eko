class Function < ActiveRecord::Base
  has_many :job_functions
  has_many :jobs, through: :job_functions
end