class QuestionAnswer < ActiveRecord::Base 
  belongs_to :application
  belongs_to :question
  belongs_to :candidate
end