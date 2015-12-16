require 'spec_helper'

describe Company do 
  it { should have_many(:users) }
  it { should have_many(:job_postings) }
  it { should have_many(:subsidiaries) }
  it { should have_many(:locations) }
end