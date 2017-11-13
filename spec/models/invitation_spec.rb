require 'spec_helper'

describe Invitation do 
  it { should belong_to(:user) }
  it { should belong_to(:company) }
  it { should validate_presence_of(:recipient_email)}
  it { should validate_presence_of(:message)}
  it { should validate_presence_of(:user_role)}
  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}
end