require 'spec_helper'

feature "create a job template" do 
  before do
    sign_in_business
    visit business_job_templates_path
  end

  scenario "creates a short answer question", js: true do
    click_link('Add Question')
    fill_in_question_text
    click_button "Create"
    expect(page).to have_content("How old are you?")
  end

  scenario "flashes error on text answer question", js: true do
    click_link('Add Question')
    click_button "Create"
    expect(page).to have_content("can't be blank")
  end


  def fill_in_question_text
    fill_in 'question[body]', with: "How old are you?"
  end
end