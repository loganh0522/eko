class WorkExperience < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :company_name, :description
end 