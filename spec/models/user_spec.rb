require 'spec_helper'

describe User do 
  it { should belong_to(:company) }
  it { should have_many(:invitations) }
  it { should have_many(:hiring_teams) }
  it { should have_many(:jobs).through(:hiring_teams) }
end