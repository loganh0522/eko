class SectionOption < ActiveRecord::Base
  belongs_to :scorecard_section
  has_many :scorecard_ratings, dependent: :destroy
  validates_presence_of :body
end