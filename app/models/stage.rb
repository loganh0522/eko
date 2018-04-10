class Stage < ActiveRecord::Base 
  belongs_to :job
  has_many :applications
  has_many :stage_actions
  has_many :application_stages
  
  validates_presence_of :name
  validates_numericality_of :position, only_integer: true
end 