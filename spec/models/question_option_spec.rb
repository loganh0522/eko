require 'spec_helper'

describe QuestionOption do 
  it { should belong_to(:question) }
  it {should validate_presence_of(:body)}
end