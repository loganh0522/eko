class JobPosting < ActiveRecord::Base

  validates_presence_of :title, :benefits, :description, :country, :city, :province
end