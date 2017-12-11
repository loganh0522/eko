require 'spec_helper'

describe Question do 
  it { should belong_to(:job) }
  it { should have_many(:question_options).dependent(:destroy)}
  it { should have_many(:question_answers).dependent(:destroy)}

  it {should validate_presence_of(:body)}
  it {should validate_presence_of(:kind)}
  it {should accept_nested_attributes_for(:question_options) }
end