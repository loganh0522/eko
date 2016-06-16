class State < ActiveRecord::Base
  belongs_to :country 

  has_many :job_states
end