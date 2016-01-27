class Application < ActiveRecord::Base 
  belongs_to :applicant, class_name: 'User', foreign_key: :user_id
  belongs_to :apps, class_name: 'Job', foreign_key: :job_id
  
  belongs_to :stage
end