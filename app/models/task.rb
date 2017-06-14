class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :taskable, polymorphic: true
end