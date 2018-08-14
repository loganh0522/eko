class CompanyUser < ActiveRecord::Base
  belongs_to :user, :inverse_of => :company_users
  belongs_to :company, :inverse_of => :company_users

  accepts_nested_attributes_for :user
  validates_associated :user


  # accepts_nested_attributes_for :company
  # validates_associated :company
  # validates :user_id, 
  #   :uniqueness => {:scope => [:assignable_id, :assignable_type]}
end