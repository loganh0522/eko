class JobFunction < ActiveRecord::Base 
  belongs_to :job 
  belongs_to :function
end