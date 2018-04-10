class StageAction < ActiveRecord::Base
  belongs_to :stage
  belongs_to :user, foreign_key: :assigned_to
  belongs_to :job
  
  has_many :tasks
  has_one :interview
  has_one :interview_invitation
  belongs_to :interview_kit_template
  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false

  validates_presence_of :name
  validates_presence_of :subject, :message, if: :is_email?

  after_create :create_stage_action_for_application_stage 

  def is_email? 
    kind == 'Email'
  end

  def is_interview? 
    kind == "Interview"
  end


  def create_stage_action_for_application_stage
    if self.stage_id.present?
      self.stage.application_stages.each do |stage| 
        @stage_action = StageAction.create(self.attributes.except("id", "stage_id").merge!(application_stage_id: stage.id))
        @stage_action.users << self.users 
      end
    end
  end
end