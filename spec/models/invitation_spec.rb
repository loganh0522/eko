require 'spec_helper'

describe Invitation do 
  it { should belong_to(:inviter) }
  it { should belong_to(:company) }
  it { should validate_presence_of(:recipient_email)}
  it { should validate_presence_of(:message)}
  it { should validate_presence_of(:user_role)}
end