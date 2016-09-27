class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :trackable, polymorphic: true
end