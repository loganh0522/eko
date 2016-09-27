class UserCertification < ActiveRecord::Base
  belongs_to :user
  belongs_to :certification

  validates_uniqueness_of :certification
end