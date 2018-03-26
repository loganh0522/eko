class CompletedAssessment < ActiveRecord::Base 
  belongs_to :assessment
  belongs_to :user
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: :true
end