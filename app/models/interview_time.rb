class InterviewTime < ActiveRecord::Base
  belongs_to :interview
  has_many :event_ids
  belongs_to :interview_invitation

  validates_presence_of :date, :time
  
  def convert_date
    return DateTime.parse(self.date)
  end
end
