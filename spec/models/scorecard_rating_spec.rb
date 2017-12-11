require 'spec_helper'

describe ScorecardRating do 
  it { should belong_to(:application_scorecard) }
  it { should belong_to(:section_option)}
  it { should validate_presence_of(:rating) }
end