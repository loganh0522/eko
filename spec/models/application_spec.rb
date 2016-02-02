require 'spec_helper'

describe Application do 
  it { should belong_to(:user) }
  it { should belong_to(:job) }
  it { should belong_to(:stage)}
end