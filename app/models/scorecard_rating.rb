class ScorecardRating < ActiveRecord::Base 
  belongs_to :application_scorecard
  belongs_to :interview_scorecard
  belongs_to :scorecard_answer

  belongs_to :section_option
  belongs_to :user
  
  validates_presence_of :rating
end