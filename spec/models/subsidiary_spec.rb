require "spec_helper" 

describe Subsidiary do 
  it { should belong_to(:company)}
  it { should validate_presence_of(:name)}
end