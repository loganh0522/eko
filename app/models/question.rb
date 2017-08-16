class Question < ActiveRecord::Base
  belongs_to :job
  has_many :question_options, dependent: :destroy
  has_many :question_answers, dependent: :destroy

  validates_presence_of :body
  validates_associated :question_options

  accepts_nested_attributes_for :question_options, 
    allow_destroy: true
end