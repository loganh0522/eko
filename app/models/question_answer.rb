class QuestionAnswer < ActiveRecord::Base 
  belongs_to :application
  belongs_to :question
end