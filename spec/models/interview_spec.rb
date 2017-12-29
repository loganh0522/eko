require 'spec_helper'

describe Interview do 
  it { should belong_to(:job) }
  it { should belong_to(:company) }
  it { should belong_to(:candidate) }
  it { should have_many(:event_ids).dependent(:destroy) }
  it { should have_many(:assigned_users).dependent(:destroy) }
  it { should have_many(:users).through(:assigned_users) }

  it {should validate_presence_of(:candidate_id)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:kind)}
  it {should validate_presence_of(:date)}
  it {should validate_presence_of(:start_time)}
  it {should validate_presence_of(:end_time)}
end