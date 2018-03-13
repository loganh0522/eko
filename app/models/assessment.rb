class Assessment < ActiveRecord::Base 
  belongs_to :candidate
  belongs_to :application
  belongs_to :interview

  has_one :scorecard
  has_many :scorecard_answers


  accepts_nested_attributes_for :scorecard, allow_destroy: true

  def completed_scorecards(assessment)
    ScorecardAnswer.where(assessment_id: assessment.id)
  end
end