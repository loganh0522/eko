class AssessmentTemplate < ActiveRecord::Base 
  belongs_to :company
  has_many :questions

  validates_presence_of :name
  validates_associated :questions
  
  accepts_nested_attributes_for :questions, 
    allow_destroy: true
end
