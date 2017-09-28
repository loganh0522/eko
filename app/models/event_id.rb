class EventId < ActiveRecord::Base
  belongs_to :interview_time
  belongs_to :user
  belongs_to :interview
  belongs_to :room
end