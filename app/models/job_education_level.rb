class JobEducationLevel < ActiveRecord::Base
  belongs_to :job
  belongs_to :education_level
end