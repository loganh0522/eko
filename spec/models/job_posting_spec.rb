require 'spec_helper'

describe JobPosting do 
  it { should belong_to(:company) }
end