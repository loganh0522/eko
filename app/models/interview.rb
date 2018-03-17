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
    @template = InterviewKitTemplate.find(self.interview_kit_template_id)
    @kit = InterviewKit.create(@template.attributes.except('id'))
    

    # @kit = InterviewKit.create(title: @template.title,
    #   preperation: @template.preperation, stage_action_id: @stage_action)
    
    @scorecard = Scorecard.create(interview_kit_id: @kit.id)

    @template.questions.each do |question| 
      @question = Question.create(question.attributes.except('id'))

      @question.update_attributes(interview_kit_id: @kit.id)
      question.question_options.each do |option|
        QuestionOption.create(question_id: @question.id, body: option.body)
      end
    end

    @template.scorecard.scorecard_sections.each do |section| 
      @section = ScorecardSection.create(scorecard_id: @scorecard.id, body: section.body) 
      
      section.section_options.each do |option| 
        SectionOption.create(scorecard_section: @section, body: option.body)
      end
    end
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
