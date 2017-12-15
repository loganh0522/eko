require 'spec_helper'

describe Comment do 
  it { should belong_to(:user) }
  it { should have_one(:activity).dependent(:destroy) }
  it { should validate_presence_of(:body) }
end