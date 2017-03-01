class Accomplishment < ActiveRecord::Base
  belongs_to :work_experience

  validates_presence_of :body
end