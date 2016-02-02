require 'spec_helper'

describe Application do 
  it { should belong_to(:applicant) }
  it { should belong_to(:apps) }
  it { should belong_to(:stage)}
end