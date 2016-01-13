class Stage < ActiveRecord::Base 
  belongs_to :job

  validates_numericality_of :position, only_integer: true
end 