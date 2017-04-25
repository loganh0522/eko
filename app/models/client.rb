class Client < ActiveRecord::Base
  belongs_to :company
  has_many :client_contacts
  has_many :jobs
end