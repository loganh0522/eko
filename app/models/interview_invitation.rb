class InterviewInvitation < ActiveRecord::Base
  belongs_to :job
  belongs_to :company
  has_many :interview_times, :dependent => :destroy

  has_many :invited_candidates, :dependent => :destroy
  has_many :candidates, through: :invited_candidates

  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false


  has_one :room, through: :assigned_rooms, validate: false

  before_create :set_token

  validates_presence_of :kind, :candidate_ids, :user_ids, :message, :subject
  
  validate :at_least_one_interview_time
  validates_associated :interview_times

  accepts_nested_attributes_for :interview_times,
    allow_destroy: true

  searchkick 

  def search_data
    attributes.merge(
      users: users.map(&:id),
      candidates: candidates.map(&:id)
    )
  end

  def send_email
    if self.user.google_token.present? 
      @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
      GoogleWrapper::Gmail.send_message(@email, current_user, message)
    elsif self.user.outlook_token.present?
      OutlookWrapper::Mail.send_message(self.user, self.subject, self.body, self.messageable.email)
    else 
      AppMailer.send_applicant_message(self.candidate.token, self.body, self.job, self.candidate.email, self.user.company).deliver
    end
  end

  def schedule_in_calendar(interview_invite, users)
    @users = interview_invite.users
    
    @users.each do |user| 
      if user.outlook_token.present?
        @times = interview_invite.interview_times
        @email = user.email          
        
        @times.each do |time| 
          date = time.date
          dateTime = DateTime.parse(time.time).strftime("%H:%M:%S")
          endTime = dateTime.chop[0..-5] + "30:00"
          @dateTime = date + "T" + dateTime
          @endTime = date + "T" + endTime

          OutlookWrapper::Calendar.create_event(user, @dateTime, @endTime, time)
        end
      end
    end
  end
  
  def to_param
    self.token
  end

  def set_token
    self.token = SecureRandom.hex(5)
  end

  private
  
  def at_least_one_interview_time
    # when creating a new contact: making sure at least one team exists
    return errors.add :add_times, "Must have at least one interview time" unless interview_times.length > 0

    # when updating an existing contact: Making sure that at least one team would exist
    # return errors.add :base, "Must have at least one Team" if interview_times.reject{|time| time._destroy == true}.empty?
  end      



end