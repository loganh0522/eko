class ApplicationStage < ActiveRecord::Base 
  belongs_to :application
  belongs_to :stage
  
  has_many :stage_actions
  
  validates_presence_of :name
  validates_numericality_of :position, only_integer: true
end 