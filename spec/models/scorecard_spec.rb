require 'spec_helper'

describe Scorecard do 
  it { should belong_to(:job) }
  it { should have_many(:scorecard_sections).dependent(:destroy)}
  it {should accept_nested_attributes_for(:scorecard_sections) }
end