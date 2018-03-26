class Assessment < ActiveRecord::Base 
  belongs_to :candidate
  belongs_to :application
  belongs_to :interview
  
  has_many :completed_assessments
  has_many :questions
  has_one :scorecard

  accepts_nested_attributes_for :scorecard, allow_destroy: true


  def completed_scorecards(assessment)
    ScorecardAnswer.where(assessment_id: assessment.id)
  end



end