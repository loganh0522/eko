class ApplicationScorecard < ActiveRecord::Base 
  has_many :scorecard_ratings, dependent: :destroy
  has_many :overall_ratings, dependent: :destroy
  belongs_to :application
  belongs_to :user

  accepts_nested_attributes_for :scorecard_ratings, allow_destroy: :true
  accepts_nested_attributes_for :overall_ratings, allow_destroy: :true
end