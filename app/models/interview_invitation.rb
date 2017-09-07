class InterviewInvitation < ActiveRecord::Base
  belongs_to :job
  belongs_to :company
  has_many :interview_times, :dependent => :destroy

  has_many :invited_candidates, :dependent => :destroy
  has_many :candidates, through: :invited_candidates

  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false

  before_create :set_token

  validates_presence_of :kind, :candidate_ids, :user_ids, :title, :message, :subject
  
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