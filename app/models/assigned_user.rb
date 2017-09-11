class AssignedUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignable, polymorphic: true

  validates_presence_of :user_id

  # validates :user_id, 
  #   :uniqueness => {:scope => [:assignable_id, :assignable_type]}
end