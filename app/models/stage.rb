class Stage < ActiveRecord::Base 
  belongs_to :job
  has_many :applications
  validates_presence_of :name
  validates_numericality_of :position, only_integer: true
end 