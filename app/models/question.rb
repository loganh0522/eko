class Question < ActiveRecord::Base
  belongs_to :questionairre
  has_many :question_options, dependent: :destroy
  has_many :question_answers

  accepts_nested_attributes_for :question_options, allow_destroy: true, reject_if: proc { |a| a[:body].blank? }
end