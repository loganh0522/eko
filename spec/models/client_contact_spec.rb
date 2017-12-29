require 'spec_helper'

describe ClientContact do 
  it { should belong_to(:company) }
  it { should have_many(:client_contacts).dependent(:destroy) }
  it { should have_many(:jobs).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:tasks).dependent(:destroy) }
  it { should validate_presence_of(:company_name) }
end