class Application < ActiveRecord::Base 
  belongs_to :applicant, class_name: 'User', foreign_key: :user_id
  belongs_to :apps, class_name: 'Job', foreign_key: :job_id 
  belongs_to :stage
  belongs_to :company

  has_many :comments, -> {order("created_at DESC")}
  has_many :application_scorecards
  has_many :messages, -> {order("created_at DESC")}
  has_many :activities, -> {order("created_at DESC")}

  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :question_answers, allow_destroy: true
end