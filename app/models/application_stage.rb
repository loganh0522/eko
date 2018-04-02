class ApplicationStage < ActiveRecord::Base 
  belongs_to :application
  has_many :stage_actions
  
  validates_presence_of :name
  validates_numericality_of :position, only_integer: true
end 