require 'spec_helper'

describe Task do 
  it { should belong_to(:company) }
  it { should belong_to(:user) }

  it { should have_many(:assigned_candidates) }
  it { should have_many(:candidates).through(:assigned_candidates) }

  it { should have_many(:assigned_users) }
  it { should have_many(:users).through(:assigned_users) }

  it { should have_one(:activity).dependent(:destroy)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:company_id)}
  it {should validate_presence_of(:kind)}
  it {should validate_presence_of(:status)}
end