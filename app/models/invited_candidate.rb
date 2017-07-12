class InvitedCandidate < ActiveRecord::Base
  belongs_to :interview_invitation
  belongs_to :candidate 

  validates_presence_of :candidate_id, :interview_invitation
  # validates_uniqueness_of :candidate_id, :interview_invitation_id
end