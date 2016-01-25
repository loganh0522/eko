require 'spec_helper' 

describe Job do 
  it { should belong_to(:company) }
  it { should have_many(:hiring_teams) }
  it { should have_many(:users).through(:hiring_teams) }
  it { should have_many(:stages) }
  it { should have_many(:applications)}
end