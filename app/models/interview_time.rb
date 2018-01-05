class InterviewTime < ActiveRecord::Base
  belongs_to :interview
  has_many :event_ids, :dependent => :destroy
  belongs_to :interview_invitation

  validates_presence_of :start_time, :end_time
  
  def convert_date
    return DateTime.parse(self.date)
  end
end
