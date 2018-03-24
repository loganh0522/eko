class CompletedAssessment < ActiveRecord::Base 
  belongs_to :assessment
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_answers, dependent: :destroy
  

  accepts_nested_attributes_for :answers, allow_destroy: :true, reject_if: :reject_rating


  

  def reject_rating(attributes)
    attributes['rating'].blank?
  end
end