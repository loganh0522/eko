require 'spec_helper' 

describe Job do 
  it { should belong_to(:company) }
  it { should have_many(:hiring_teams) }
  it { should have_many(:users).through(:hiring_teams) }
  it { should have_many(:industries).through(:job_industries) }
  it { should have_many(:functions).through(:job_functions) }
  it { should have_many(:candidates).through(:applications) }
  it { should have_many(:stages) }
  it { should have_many(:applications)}
  it { should have_many(:comments) }
  it { should have_many(:tasks) }
  it { should have_one(:scorecard) }
  it { should have_one(:questionairre) }
  
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:address)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:location)}



end