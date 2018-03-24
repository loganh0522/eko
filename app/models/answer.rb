class Answer < ActiveRecord::Base 
  belongs_to :section_option
  belongs_to :question
  belongs_to :completed_assessment
  belongs_to :user
  
  validates_presence_of :rating
end