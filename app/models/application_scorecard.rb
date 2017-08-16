class ApplicationScorecard < ActiveRecord::Base 
  has_many :scorecard_ratings, dependent: :destroy
  # has_many :overall_ratings, dependent: :destroy
  belongs_to :application
  belongs_to :user

  accepts_nested_attributes_for :scorecard_ratings, allow_destroy: :true, reject_if: :reject_rating


  def reject_rating(attributes)
    attributes['rating'].blank?
  end
end