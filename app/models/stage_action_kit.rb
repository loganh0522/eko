class StageActionKit < ActiveRecord::Base 
  belongs_to :interview_kit_template
  belongs_to :stage_action
end