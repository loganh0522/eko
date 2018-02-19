class ScorecardRating < ActiveRecord::Base 
  belongs_to :application_scorecard
  belongs_to :section_option
  belongs_to :user
  belongs_to :interview_scorecard
  validates_presence_of :rating
end