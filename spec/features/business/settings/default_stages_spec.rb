require 'spec_helper'

feature "creating a hiring process" do 
  before do 
    sign_in_business
    visit business_default_stages_path
  end

  scenario "creates a stage", js: true do
    click_link('Create Stage')
    fill_in_stage
    click_button "Create Stage"
    expect(page).to have_content("Check References")
  end

  scenario "does not create a stage", js: true do
    click_link('Create Stage')
    click_button "Create Stage"
    expect(page).to have_content("can't be blank")
  end

  scenario "edits the stage", js: true do
    page.first(:css, '.stage').first(:css, '.fa-ellipsis-h').click
    click_link('Edit')
    fill_in_stage
    click_button "Update"
    expect(page).to have_content("Check References")
  end

  scenario "destroys the stage", js: true do
    page.first(:css, '.stage').first(:css, '.fa-ellipsis-h').click
    click_link('Destroy')
    page.first(:css, '.confirm').click
    expect(page).to_not have_content("Screen")
  end

  def fill_in_stage
    fill_in "Stage Name", with: "Check References"
  end
end