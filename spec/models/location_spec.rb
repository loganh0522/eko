require 'spec_helper'

describe Location do 
  it { should belong_to(:company) }
  it { should belong_to(:subsidiary) }
end