class ScorecardSection < ActiveRecord::Base
  belongs_to :scorecard
  has_many :section_options, dependent: :destroy
  
  validates_presence_of :body
  validates_associated :section_options

  accepts_nested_attributes_for :section_options, 
    allow_destroy: true

end