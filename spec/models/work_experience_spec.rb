require 'spec_helper'

describe WorkExperience do 
  it { should belong_to(:user) }
end