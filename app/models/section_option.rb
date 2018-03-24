class SectionOption < ActiveRecord::Base
  belongs_to :scorecard_section
  has_many :answers, dependent: :destroy
  validates_presence_of :body
end