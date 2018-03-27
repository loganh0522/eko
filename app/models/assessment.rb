class Assessment < ActiveRecord::Base 
  belongs_to :candidate
  belongs_to :application
  belongs_to :interview
  
  has_many :completed_assessments
  has_many :questions
  has_one :scorecard

  has_many :assigned_users, as: :assignable
  has_many :users, through: :assigned_users

  accepts_nested_attributes_for :scorecard, allow_destroy: true


  def completed_scorecards(assessment)
    ScorecardAnswer.where(assessment_id: assessment.id)
  end


  def pending
    @pending = []
    
    if self.interview.present?
      self.interview.users.each do |user| 
        if !CompletedAssessment.where(user: user, assessment_id: self.id).present?
          @pending << user
        end
      end
    else 
      self.users.each do |user|
        if !CompletedAssessment.where(user: user, assessment_id: self.id).present?
          @pending << user
        end
      end
    end

    return @pending
  end


end