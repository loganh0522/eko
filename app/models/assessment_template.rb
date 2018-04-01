class AssessmentTemplate < ActiveRecord::Base 
  belongs_to :company
  has_many :questions
  accepts_nested_attributes_for :questions, 
    allow_destroy: true
end
