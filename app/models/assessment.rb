class Assessment < ActiveRecord::Base 
  belongs_to :candidate
  belongs_to :application
  belongs_to :interview
  has_many :questions
  has_one :scorecard
  has_many :scorecard_answers
  has_many :question_answers

  accepts_nested_attributes_for :scorecard, allow_destroy: true


  accepts_nested_attributes_for :question_answers, allow_destroy: true
  accepts_nested_attributes_for :scorecard_answers, allow_destroy: true

  def completed_scorecards(assessment)
    ScorecardAnswer.where(assessment_id: assessment.id)
  end
end