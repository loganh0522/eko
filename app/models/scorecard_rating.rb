class ScorecardRating < ActiveRecord::Base 
  belongs_to :application_scorecard, dependent: :destroy
  belongs_to :section_option, dependent: :destroy
end