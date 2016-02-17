class JobCareerLevel < ActiveRecord::Base
  belongs_to :job
  belongs_to :career_level
end