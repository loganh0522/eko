class Industry < ActiveRecord::Base
  has_many :job_industries
  has_many :jobs, through: :job_industries
  has_many :work_experiences, through: :job_industries
end