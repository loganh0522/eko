class AssignedUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignable, polymorphic: true
end