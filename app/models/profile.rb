class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :work_experiences, -> {order("end_year DESC")} 
  has_many :educations
  has_many :user_certifications
  

  has_many :user_skills
  has_many :skills, through: :user_skills
  
  accepts_nested_attributes_for :work_experiences, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :user_certifications, allow_destroy: true, reject_if: proc { |a| a[:body].blank? }
end