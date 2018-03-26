class Answer < ActiveRecord::Base 
  belongs_to :section_option
  belongs_to :question
  belongs_to :question_option
  
  belongs_to :completed_assessment
  belongs_to :user

  before_create :add_user, if: :is_completed_assessment?

  def add_user
    @user = self.completed_assessment.user
    self.user = @user
  end

  def is_completed_assessment?
    self.completed_assessment.present? 
  end
end