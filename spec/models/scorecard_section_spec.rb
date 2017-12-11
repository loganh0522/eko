require 'spec_helper'

describe ScorecardSection do 
  it { should belong_to(:scorecard) }
  it { should have_many(:section_options).dependent(:destroy)}
  it {should validate_presence_of(:body) }
  it {should accept_nested_attributes_for(:section_options) }
end