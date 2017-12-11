require 'spec_helper'

describe HiringTeam do 
  it { should belong_to(:user) }
  it { should belong_to(:job) }
  it {should validate_presence_of(:user_id)}
  it {should validate_uniqueness_of(:user_id).scoped_to(:job_id).with_message("This user is already a member of this Job")}
end