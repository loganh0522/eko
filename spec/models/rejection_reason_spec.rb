require 'spec_helper'

describe RejectionReason do 
  it { should belong_to(:company) }
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:company_id)}
end