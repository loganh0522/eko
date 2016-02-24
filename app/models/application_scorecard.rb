class ApplicationScorecard < ActiveRecord::Base 
  has_many :scorecard_ratings
  belongs_to :application
  belongs_to :user

  accepts_nested_attributes_for :scorecard_ratings
end