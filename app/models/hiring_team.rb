class HiringTeam < ActiveRecord::Base
  belongs_to :user 
  belongs_to :job
  
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, :scope => :job_id, :message => "This user is already a member of this Job"
end

