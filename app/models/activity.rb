class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :company, -> {order("created_at DESC")}
  belongs_to :job
  belongs_to :trackable, polymorphic: true
end