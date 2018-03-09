class InterviewKitTemplate < ActiveRecord::Base
  belongs_to :company, -> {order("created_at DESC")}
  belongs_to :job
  belongs_to :application
  has_many :interviews
  has_many :stage_actions
  has_many :interview_scorecards
  has_one :scorecard


  accepts_nested_attributes_for :scorecard, 
    allow_destroy: true
end