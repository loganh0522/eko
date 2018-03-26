class QuestionOption < ActiveRecord::Base
  belongs_to :question
  has_many :answers
  validates_presence_of :body
end