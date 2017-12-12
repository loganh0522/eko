require 'spec_helper'

describe Task do 
  it { should belong_to(:company) }
  it { should belong_to(:user) }
  it { should have_many(:invitations) }
  it { should have_many(:hiring_teams) }
  it { should have_many(:jobs).through(:hiring_teams) }



end