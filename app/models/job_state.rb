class JobState < ActiveRecord::Base
  belongs_to :state 
  belongs_to :work_experience
  belongs_to :user
  belongs_to :job 
end