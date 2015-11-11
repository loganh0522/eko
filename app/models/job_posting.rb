class JobPosting < ActiveRecord::Base
  belongs_to :company

  validates_presence_of :title, :benefits, :description, :country, :city, :province
end