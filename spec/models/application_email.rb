require 'spec_helper'

describe WorkExperience do 
  it { should belong_to(:job) }
  it { should belong_to(:company) }

  it {should validate_presence_of(:body)}
  it {should validate_presence_of(:subject)}
end