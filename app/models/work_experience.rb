class WorkExperience < ActiveRecord::Base
  belongs_to :user
  has_one :industry
  has_one :job_function

  validates_presence_of :title, :company_name, :description
end 