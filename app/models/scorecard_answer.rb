class ScorecardAnswer < ActiveRecord::Base 
  has_many :scorecard_ratings, dependent: :destroy
  belongs_to :application
  belongs_to :user
  belongs_to :application
  belongs_to :scorecard
  belongs_to :assessment
  belongs_to :candidate
  belongs_to :interview_kit
  belongs_to :interview
  belongs_to :stage_action

  accepts_nested_attributes_for :scorecard_ratings, allow_destroy: :true, reject_if: :reject_rating


  def reject_rating(attributes)
    attributes['rating'].blank?
  end
end