require 'spec_helper'

describe Stage do 
  it { should belong_to(:job) }
  it { should have_many(:applications) }
  it { should validate_presence_of(:name) }
end