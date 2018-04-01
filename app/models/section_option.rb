class SectionOption < ActiveRecord::Base
  belongs_to :scorecard_section
  belongs_to :scorecard
  belongs_to :scorecard_template
  
  has_many :answers, dependent: :destroy
  validates_presence_of :body
end