class Company < ActiveRecord::Base
  has_many :users
  has_many :invitations
  
  has_many :job_postings
  has_many :subsidiaries
  has_many :locations


  
  validates_presence_of :name, :website
end