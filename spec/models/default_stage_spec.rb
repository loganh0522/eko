require 'spec_helper'

describe DefaultStage do 
  it { should belong_to(:company) }
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:company_id)}
end