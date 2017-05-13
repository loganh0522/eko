class Candidate < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  has_many :applications
  has_many :ratings
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
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def current_jobs
    @current_jobs = self.work_experiences.where(current_position: true)
    return @current_jobs
  end

  def current_user_rating_present?(current_user)
    self.ratings.each do |rating| 
      if rating.user == current_user
        return true   
      end
    end
    return false
  end

 
end
