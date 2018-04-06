class Application < ActiveRecord::Base  
  before_create :generate_token
  belongs_to :company
  belongs_to :stage
  belongs_to :candidate
  belongs_to :job

  has_many :application_stages, dependent: :destroy

  has_many :interview_scorecards
  has_many :ratings
  has_many :application_scorecards
  
  has_many :assessments
  has_many :question_answers, dependent: :destroy

  after_create :reindex_candidate
  after_update :reindex_candidate, :create_stage_actions

  def reindex_candidate
    Candidate.find(candidate.id).reindex
  end

  accepts_nested_attributes_for :question_answers, allow_destroy: true
  
  
  def create_process
    @job = self.job 

    @job.stages.each do |stage| 
      @stage = ApplicationStage.create(stage.attributes.except("id").merge!(application_id: self.id) )
      
      stage.stage_actions.each do |action| 
        @action = StageAction.create(action.attributes.except("id", "stage_id").merge!(application_stage_id: @stage.id))
        @action.users << action.users
      end
    end
  end
  

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end


  ######### ElasticSearch ##############

  def app_stage
    applied = "Applied"
    rejected = "Rejected"
    if self.rejected == true
      return rejected
    elsif self.stage.present?
      self.stage.name
    elsif 
      applied
    end
  end

  def current_user_rating_present?(current_user, application)
    application.ratings.each do |rating| 
      if rating.user == current_user
        return true   
      end
    end

    return false
  end

  def current_user_rating(current_user)
    self.ratings.each do |rating| 
      if rating.user == current_user
        return rating.score 
      end
    end
    return false
  end

  def average_rating 
    self.ratings.average(:score).to_f.round(1) if ratings.any?
  end

  def interview_assessments
    @assessments = []

    self.interviews.each do |interview| 
      if interview.interview_kit.present? 
        @assessments.append(interview)
      end
    end
  end
 

  def create_stage_actions
    @stage_actions = self.stage.stage_actions
    
    @stage_actions.each do |action| 
      if action.kind == "Task"
        Task.create(company: self.job.company, job: self.job, title: action.name, kind: "To-do", taskable_type: "Candidate", 
          taskable_id: self.candidate.id, status: 'active', user_id: 1)
      end
    end
  end

  def current_stage
    if self.application_stages.where(current_stage: true).present?
      @current_stage = self.application_stages.where(current_stage: true).first
    elsif self.hired == true
      @current_stage = 'Hired'
    elsif self.rejected == true
      @current_stage = 'Rejected'
    else 
      @current_stage = 'Applied'
    end
  end
  # def current_position
  #   self.applicant.profile.current_position.title
  # end
end