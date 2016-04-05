class State < ActiveRecord::Base
  belongs_to :country 

  has_many :job_states
  has_many :work_experiences, through: :job_states
end