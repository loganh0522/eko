class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :company, touch: true
  belongs_to :taskable, polymorphic: true
  
  has_many :assigned_users, as: :assignable
  has_many :users, through: :assigned_users

  has_many :assigned_candidates, as: :assignable
  has_many :candidates, through: :assigned_candidates
  
  has_one :activity, as: :trackable, :dependent => :destroy

  validates_presence_of :title, :kind, :status, :company_id
  
  after_save :create_activity
  
  def my_tasks
    current_user.tasks
  end

  def create_activity
    if self.taskable_type == "Job"
      Activity.create(action: "create", trackable_type: "Task", trackable_id: self.id, user_id: self.user_id,
      company_id: self.company_id, job_id: self.job_id)
    elsif self.taskable_type == "Candidate" && self.job_id.present?
      Activity.create(action: "create", trackable_type: "Task", trackable_id: self.id, user_id: self.user_id,
      company_id: self.company_id, job_id: self.job_id, candidate_id: self.taskable_id)     
    elsif self.taskable_type == "Candidate"
      Activity.create(action: "create", trackable_type: "Task", trackable_id: self.id, user_id: self.user_id,
      company_id: self.company_id, candidate_id: self.taskable_id)
    else 
      Activity.create(action: "create", trackable_type: "Task", trackable_id: self.id, user_id: self.user_id,
      company_id: self.company_id)
    end
  end

  searchkick 

  def search_data
    attributes.merge(
      users: users.map(&:id),
      candidates: candidates.map(&:id),
    )
  end

  # def as_indexed_json(options={})
  #   as_json(
  #     only: [:taskable_type, :taskable_id, :last_name, :tag_line],
  #     include: {
  #       user: {only: [:full_name]}, 
  #       applications: {only: [:created_at, :user_id, :job_id]}        
  #       }        
  #     )
  # end
end