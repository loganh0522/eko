class InterviewInvitation < ActiveRecord::Base
  belongs_to :job
  belongs_to :company
  has_many :interview_times
  
  has_many :invited_candidates
  has_many :candidates, through: :invited_candidates

  has_many :assigned_users, as: :assignable
  has_many :users, through: :assigned_users, validate: false

  before_create :set_token

  validates_presence_of :kind, :candidate_ids, :user_ids, :title, :message, :subject

  accepts_nested_attributes_for :interview_times, 
    allow_destroy: true
  
  def to_param
    self.token
  end

  def set_token
    self.token = SecureRandom.hex(5)
  end
end