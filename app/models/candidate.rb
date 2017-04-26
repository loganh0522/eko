class Candidate < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  has_many :applications

  has_many :messages, as: :messageable
  has_many :comments, as: :commentable

  has_many :applicant_contact_details
  has_many :work_experiences
  has_many :educations

  accepts_nested_attributes_for :work_experiences, 
    allow_destroy: true
    # reject_if: :experience_validation

  accepts_nested_attributes_for :educations, 
    allow_destroy: true
    # reject_if: proc { |a| a[:body].blank? }

  accepts_nested_attributes_for :applicant_contact_details, 
    allow_destroy: true

  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
    return full_name
  end
  
end
