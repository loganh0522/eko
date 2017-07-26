require 'spec_helper'

describe EmailTemplate do 
  it { should belong_to(:user) }
  it { should belong_to(:company) }

  it {should validate_presence_of(:company_id)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:body)}
end