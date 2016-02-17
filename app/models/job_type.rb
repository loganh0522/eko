class JobType < ActiveRecord::Base
  belongs_to :job
  belongs_to :job_kind
end