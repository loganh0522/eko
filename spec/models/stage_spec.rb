require 'spec_helper'

describe Stage do 
  it { should belong_to(:job) }
end