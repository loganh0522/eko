class InterviewKitTemplate < ActiveRecord::Base
  belongs_to :company, -> {order("created_at DESC")}
  belongs_to :job
  belongs_to :application
  has_many :interviews
  has_many :questions, -> {order(:position)}, dependent: :destroy
  has_many :interview_scorecards
  has_one :scorecard


  has_many :stage_action_kits, dependent: :destroy
  has_many :stage_actions, through: :stage_action_kits

  validates_presence_of :title, :preperation
  validates_associated :scorecard, :questions


  accepts_nested_attributes_for :scorecard, 
    allow_destroy: true

  accepts_nested_attributes_for :questions, 
    allow_destroy: true
end