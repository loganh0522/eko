class InterviewInvitation < ActiveRecord::Base
  has_many :interview_times
  has_many :invited_candidates
  has_many :candidates, through: :invited_candidates


  before_create :set_token

  accepts_nested_attributes_for :interview_times, 
    allow_destroy: true



  
  def to_param
    self.token
  end

  def set_token
    self.token = SecureRandom.hex(5)
  end
end