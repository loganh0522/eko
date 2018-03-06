class StageAction < ActiveRecord::Base
  belongs_to :stage
  belongs_to :user, foreign_key: :assigned_to
  belongs_to :job
  
  has_many :tasks
  has_one :interview
  has_one :interview_invitation
  has_many :interview_scorecards
  belongs_to :interview_kit


  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false

  validates_presence_of :name
  validates_presence_of :subject, :message, if: :is_email?

  def is_email? 
    kind == 'Email'
  end
end