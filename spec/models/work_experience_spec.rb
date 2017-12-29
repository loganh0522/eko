require 'spec_helper'

describe WorkExperience do 
  it { should belong_to(:user) }
  it { should have_many(:user_skills).dependent(:destroy)}
  it { should have_many(:accomplishments).dependent(:destroy)}
  it { should validate_presence_of(:company_name) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_month) }
  it { should validate_presence_of(:start_year) }
  it { should validate_presence_of(:end_month) }
  it { should validate_presence_of(:end_year) }
end