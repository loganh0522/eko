require 'spec_helper'

describe Room do 
  it { should belong_to(:company) }
  it { should have_one(:outlook_token)}

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}
end