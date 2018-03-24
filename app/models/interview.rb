class Interview < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :job
  belongs_to :company
  
  belongs_to :room
  belongs_to :stage_action



  has_one :assessment
  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false
  has_many :event_ids, :dependent => :destroy

  #Validations

  validates_presence_of :title, :kind, :date, :stime, :etime, :candidate_id
  after_create :create_interview_kit
  
  searchkick

  def send_invitation
    GoogleWrapper::Calendar.create_event(current_user, e.start_time, e.end_time, 
      e.location, e.description, e.title, e.users, e.candidate)
  end

  def pending_scorecards
    @pending = []
    
    if self.assessment.present?
      self.users.each do |user| 
        if !CompletedAssessment.where(user: user, assessment_id: self.assessment.id).present?
          @pending << user
        end
      end
    end

    return @pending
  end

  def has_completed_assessment?
    self.assessment.completed_assessments.present?
  end

  
  def create_interview_kit
    @template = InterviewKitTemplate.find(self.interview_kit_template_id)

    @kit = Assessment.create(interview_id: self.id, application_id: self.application_id, 
      candidate_id: self.candidate.id, name: self.title, preperation: @template.preperation) 
   

    # @kit = InterviewKit.create(title: @template.title,
    #   preperation: @template.preperation, stage_action_id: @stage_action)
    
    @scorecard = Scorecard.create(assessment: @kit)

    @template.questions.each do |question| 
      @question = Question.create(question.attributes.except('id'))

      @question.update_attributes(assessment_id: @kit.id)

      question.question_options.each do |option|
        QuestionOption.create(question_id: @question.id, body: option.body)
      end
    end

    if @template.scorecard.present?
      @template.scorecard.scorecard_sections.each do |section| 
        @section = ScorecardSection.create(scorecard_id: @scorecard.id, body: section.body) 
        
        section.section_options.each do |option| 
          SectionOption.create(scorecard_section: @section, body: option.body)
        end
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
