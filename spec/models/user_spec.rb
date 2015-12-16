require 'spec_helper'

describe User do 
  it { should belong_to(:company) }
  it { should have_many(:invitations)}
end