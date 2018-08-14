class CompanyUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  validates_presence_of :user_id, :company_id

  validates
  # validates :user_id, 
  #   :uniqueness => {:scope => [:assignable_id, :assignable_type]}
end