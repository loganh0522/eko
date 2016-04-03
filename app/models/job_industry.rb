class JobIndustry < ActiveRecord::Base
  belongs_to :job
  belongs_to :work_experience
  belongs_to :industry
end