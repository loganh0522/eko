class InterviewKitTemplate < ActiveRecord::Base
  belongs_to :company, -> {order("created_at DESC")}
  belongs_to :job
  belongs_to :application
  has_many :interviews
  
  has_many :interview_scorecards
  has_one :scorecard


  has_many :stage_action_kits, dependent: :destroy
  has_many :stage_actions, through: :stage_action_kits


  accepts_nested_attributes_for :scorecard, 
    allow_destroy: true
end