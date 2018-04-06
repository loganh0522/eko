class ScorecardTemplate < ActiveRecord::Base 
  belongs_to :company
  has_many :section_options

  validates_presence_of :name
  validates_associated :section_options
  
  accepts_nested_attributes_for :section_options, 
    allow_destroy: true
end
