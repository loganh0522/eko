class Application < ActiveRecord::Base 
  belongs_to :applicant, class_name: 'User', foreign_key: :user_id
  belongs_to :apps, class_name: 'Job', foreign_key: :job_id 
  belongs_to :stage
  
  has_many :comments
  has_many :application_scorecards

  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :question_answers, allow_destroy: true
end