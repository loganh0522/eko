require 'spec_helper'

feature "creating a hiring process" do 
  before do 
    sign_in_business
    visit business_job_stages_path(@job)
  end

  scenario "creates a stage", js: true do
    click_link('Add Stage')
    fill_in_stage
    click_button "Create Stage"
    expect(page).to have_content("Check References")
  end

  scenario "does not create a stage", js: true do
    click_link('Add Stage')
    click_button "Create Stage"
    expect(page).to have_content("can't be blank")
  end

  scenario "creates a task for the stage", js: true do 
    find('#applied').find('.stage-footer').find(".add-task").click
    fill_in "stage_action[name]", with: "Finish Tests"
    click_button "Create Action"
    expect(page).to have_content("Finish Tests")
  end

  scenario "creates an interview for the stage", js: true do 
    find('#applied').find('.stage-footer').find(".add-interview").click
    fill_in "stage_action[name]", with: "Interview Name"
    click_button "Create"
    expect(page).to have_content("Interview Name")
  end

  scenario "creates an emails for the stage", js: true do 


  end

  def fill_in_stage
    fill_in "Stage Name", with: "Check References"
  end
end