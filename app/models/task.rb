class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :company, touch: true
  belongs_to :taskable, polymorphic: true
  
  has_many :assigned_users, as: :assignable
  has_many :users, through: :assigned_users

  has_many :assigned_candidates, as: :assignable
  has_many :candidates, through: :assigned_candidates

  validates_presence_of :title, :kind, :status, :company_id

  def my_tasks
    current_user.tasks
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