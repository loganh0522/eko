class AssignedCandidate < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :assignable, polymorphic: true

  validates_presence_of :candidate_id

  validates :candidate_id, :uniqueness => {
        :scope => [:assignable_id, :assignable_type]
    }
end