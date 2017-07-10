class InvitedCandidate < ActiveRecord::Base
  belongs_to :interview_invitation
  belongs_to :candidate 
end