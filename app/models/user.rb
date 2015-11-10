class User < ActiveRecord::Base
  belongs_to :company

  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email

  has_secure_password validations: false 
end