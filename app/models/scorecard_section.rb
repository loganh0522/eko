class ScorecardSection < ActiveRecord::Base
  belongs_to :scorecard
  has_many :section_options, dependent: :destroy
  
  accepts_nested_attributes_for :section_options, allow_destroy: true, reject_if: proc { |a| a[:body].blank? }
end