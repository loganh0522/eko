class JobCountry < ActiveRecord::Base
  belongs_to :country 
  belongs_to :work_experience
  belongs_to :job 
end