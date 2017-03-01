class UserCertification < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :name, :message => "Certification name can't be blank"
  validates_presence_of :agency, :message => "Agency can't be blank"
  validates_presence_of :start_month, :message => "Date certified can't be blank"
  validates_presence_of :start_year, :message => "Date certified can't be blank"
  validates_presence_of :end_month, :end_year, :unless => :expires?
end