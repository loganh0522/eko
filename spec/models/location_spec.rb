require 'spec_helper'

describe Location do 
  it { should belong_to(:company) }
  it { should belong_to(:subsidiary) }
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:address)}
  it { should validate_presence_of(:country)}
end