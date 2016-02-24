class Scorecard < ActiveRecord::Base
  belongs_to :job
  has_many :scorecard_sections, dependent: :destroy
  has_many :application_scorecards
  
  accepts_nested_attributes_for :scorecard_sections, allow_destroy: true, reject_if: proc { |a| a[:body].blank? }
end