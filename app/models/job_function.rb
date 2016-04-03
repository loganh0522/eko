class JobFunction < ActiveRecord::Base 
  belongs_to :job 
  belongs_to :work_experience
  belongs_to :function
end