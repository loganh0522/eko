class Industry < ActiveRecord::Base
  has_many :job_industries
  has_many :jobs, through: :job_industries
  

  has_many :exp_functions
  has_many :work_experiences, through: :exp_functions 
end