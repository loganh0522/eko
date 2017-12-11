class Education < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
  belongs_to :candidate
  
  validates_presence_of :school, :message => "School title can't be blank"
  validates_presence_of :degree, :message => "Degree can't be blank"
  # validates_presence_of :start_month, :message => "Start month can't be blank"
  # validates_presence_of :start_year, :message => "Start year can't be blank"
  # validates_presence_of :end_month, :message => "End month can't be blank"
  # validates_presence_of :end_year, :message => "End year can't be blank"
end