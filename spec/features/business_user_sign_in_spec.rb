require 'spec_helper'

feature "business user signs in" do 
  scenario "with valid email and password user signs in" do
    sign_in_business
    current_path == "/business"
    expect(page).to have_content @job.title 
  end
end