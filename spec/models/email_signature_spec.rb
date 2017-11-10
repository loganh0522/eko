require 'spec_helper'

describe EmailTemplate do 
  it { should belong_to(:user) }
  it {should validate_presence_of(:signature)}
end