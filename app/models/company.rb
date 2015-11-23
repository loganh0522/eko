class Company < ActiveRecord::Base
  has_many :users
  has_many :job_postings
  has_many :subsidiaries

  
  validates_presence_of :name, :website
end