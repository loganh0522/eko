class Scorecard < ActiveRecord::Base
  belongs_to :job
  belongs_to :interview_kit
  belongs_to :assessment
  has_many :questions, dependent: :destroy
  has_many :scorecard_sections, dependent: :destroy
  has_many :scorecard_answers, dependent: :destroy
  validates_associated :scorecard_sections
  
  accepts_nested_attributes_for :scorecard_sections, 
    allow_destroy: true



  def duplicate_scorecard(assessment={}, interview={})
    @scorecard = Scorecard.create(assessment_id: assessment.id)
    
    self.scorecard_sections.each do |section| 
      @section = ScorecardSection.create(scorecard: @scorecard, body: section.body)
      
      section.section_options.each do |option|
        SectionOption.create(body: option.body, scorecard_section: @section)
      end
    end
  end
end