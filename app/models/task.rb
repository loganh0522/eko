class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :company, touch: true
  belongs_to :taskable, polymorphic: true
  
  has_many :assigned_users, as: :assignable
  has_many :users, through: :assigned_users




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