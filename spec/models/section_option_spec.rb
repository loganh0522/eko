require 'spec_helper'

describe SectionOption do 
  it { should belong_to(:scorecard_section) }
  it { should have_many(:scorecard_ratings).dependent(:destroy)}
  it { should validate_presence_of(:body) }
end