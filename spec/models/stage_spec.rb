require 'spec_helper'

describe Stage do 
  it { should belong_to(:job) }
  it { should have_many(:applications) }
end