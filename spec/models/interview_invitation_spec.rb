require 'spec_helper'

describe InterviewInvitation do 
  it { should belong_to(:job) }
  it { should belong_to(:company) }

  it { should have_many(:interview_times) }

  it { should have_many(:assigned_users) }
  it { should have_many(:users).through(:assigned_users) }

  it { should have_many(:invited_candidates) }
  it { should have_many(:candidates).through(:invited_candidates) }

  it { should accept_nested_attributes_for(:interview_times) }

  it {should validate_presence_of(:user_ids)}
  it {should validate_presence_of(:candidate_ids)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:subject)}
  it {should validate_presence_of(:message)}
end