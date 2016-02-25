class ScorecardRating < ActiveRecord::Base 
  belongs_to :application_scorecard
  belongs_to :section_option
end