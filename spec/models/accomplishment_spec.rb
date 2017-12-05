require 'spec_helper'

describe Accomplishment do 
  it { should belong_to(:work_experience) }
  it {should validate_presence_of(:body)}
end