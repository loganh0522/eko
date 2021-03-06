require 'spec_helper'

describe Company do 
  it { should have_many(:users) }
  it { should have_many(:jobs) }
  it { should have_many(:subsidiaries) }
  it { should have_many(:locations) }
  it { should have_many(:invitations) }
end
