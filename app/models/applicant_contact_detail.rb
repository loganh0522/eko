class ApplicantContactDetail < ActiveRecord::Base
  belongs_to :application

  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
    return full_name
  end
end