require 'spec_helper'

describe Tag do 
  it { should belong_to(:company) }
  it { should have_many(:taggings).dependent(:destroy) }
  it { should validate_presence_of(:name)}
end