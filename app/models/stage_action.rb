class StageAction < ActiveRecord::Base
  belongs_to :stage
  belongs_to :user, foreign_key: :assigned_to
  has_many :tasks
  has_one :interview
  has_many :interview_scorecards
  belongs_to :interview_kit


  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false
end