class Scorecard < ActiveRecord::Base
  belongs_to :job
  has_many :scorecard_sections, dependent: :destroy
  validates_associated :scorecard_sections
  accepts_nested_attributes_for :scorecard_sections, 
    allow_destroy: true
end