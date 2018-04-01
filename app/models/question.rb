class Question < ActiveRecord::Base
  belongs_to :job
  belongs_to :interview_scorecard
  belongs_to :scorecard
  belongs_to :assessment_template
  belongs_to :interview_kit_template
  belongs_to :interview_kit
  belongs_to :assessment
  has_many :answers
  has_many :question_options, dependent: :destroy
  has_many :question_answers, dependent: :destroy

  validates_presence_of :body, :kind
  validates_associated :question_options

  # validates_numericality_of :position, only_integer: true

  accepts_nested_attributes_for :question_options, 
    allow_destroy: true
    


  def downcase
    self.kind = self.kind.downcase
  end
end