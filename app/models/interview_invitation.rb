class InterviewInvitation < ActiveRecord::Base
  has_many :interview_times
  belongs_to :candidate 

  before_create :set_token
  
  def to_param
    self.token
  end

  def set_token
   self.token = SecureRandom.hex(5)
  end
end