class HiringTeam < ActiveRecord::Base
  belongs_to :user 
  belongs_to :job
  
  validates_presence_of :user_id
end
