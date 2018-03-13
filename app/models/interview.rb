class Interview < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :job
  belongs_to :company
  has_many :event_ids, :dependent => :destroy
  belongs_to :room
  belongs_to :stage_action
  belongs_to :interview_kit
  has_many :interview_scorecards
  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false
  
  validates_presence_of :title, :kind, :date, :stime, :etime, :candidate_id
  after_create :create_interview_kit
  searchkick

  def send_invitation
    GoogleWrapper::Calendar.create_event(current_user, e.start_time, e.end_time, 
      e.location, e.description, e.title, e.users, e.candidate)
  end

  def pending_scorecards
    @pending = []
    
    if self.interview_kit.present?
      self.users.each do |user| 
        if !InterviewScorecard.where(user: user, interview: self).present?
          @pending << user
        end
      end
    end
    return @pending
  end

  def create_interview_kit
    @assessment = Assessment.create(interview: self, 
      candidate: self.candidate, application_id: self.application_id, name: self.title)

    @interview_kit = InterviewKit.create(InterviewKitTemplate.find(self.interview_kit_template_id).attributes)

    @interview_kit.scorecard.update_attributes(assessment: @assessment)
  end

  def scorecards_completed?
    self.interview_scorecards.count == self.users.count
  end

  def month
    Date.parse(self.date).strftime("%B")
  end

  def day
    Date.parse(self.date).strftime("%d")
  end

  def year
    Date.parse(self.date).strftime("%Y")
  end
end
