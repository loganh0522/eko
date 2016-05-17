class Function < ActiveRecord::Base
  has_many :job_functions
  has_many :jobs, through: :job_functions

  has_many :exp_functions
  has_many :work_experiences, through: :exp_functions 
end