class Location < ActiveRecord::Base 
  belongs_to :company
  belongs_to :subsidiary

  validates_presence_of :name, :address, :country
end