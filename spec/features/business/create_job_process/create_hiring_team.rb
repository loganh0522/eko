require 'spec_helper'

feature "creating hiring team" do 
  scenario "creates a short answer question", js: true do
    sign_in_business
    page.should have_content @job.title
    visit business_job_questions_path(@job)
    click_link('Add Question')
    fill_in_question_text
    click_button "Create"
    expect(page).to have_content("How old are you?")
  end



end