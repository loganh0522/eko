class JobKind < ActiveRecord::Base
  has_many :job_types
  has_many :jobs, through: :job_types
end