class Assessment < ActiveRecord::Base 
  belongs_to :candidate
  belongs_to :application
  belongs_to :interview
  
  has_one :scorecard
  has_many :scorecard_answers

end