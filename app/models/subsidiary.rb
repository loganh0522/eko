class Subsidiary < ActiveRecord::Base 
  belongs_to :company
  has_many :locations

  validates_presence_of :name
end