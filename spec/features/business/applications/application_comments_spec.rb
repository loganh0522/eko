require 'spec_helper'

feature "creating a comment on an application" do 
  before do 
    sign_in_business
    visit business_candidates_path
  end

  scenario "creates a stage", js: true do
    click_link('Add Candidate')
    fill_in_candidate_form
    click_button "Create Stage"
    expect(page).to have_content("Check References")
  end

  def fill_in_stage
    fill_in "Stage Name", with: "Check References"
  end
end