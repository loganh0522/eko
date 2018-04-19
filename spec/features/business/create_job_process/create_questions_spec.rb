require 'spec_helper'

feature "creating an application form" do 
  before do
    sign_in_business
    visit business_job_questions_path(@job)
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

  scenario "creates a multiple choice answer question", js: true do
    click_link('Add Question')
    select('Multiselect', from: 'question[kind]')
    fill_in_question_text
    page.all(:css, ".section-answer").first.set 'Answer 1'
    page.all(:css, ".section-answer").last.set 'Answer 2'
    find(".add_fields").click
    page.all(:css, ".section-answer").last.set 'Answer 3'
    click_button "Create"
  end

  scenario "creates a multiple choice answer question", js: true do
    click_link('Add Question')
    select('Multiselect', from: 'question[kind]')
    fill_in_question_text
    page.all(:css, ".section-answer").first.set 'Answer 1'
    click_button "Create"
    expect(page).to have_content("can't be blank")
  end

  scenario "cancels the option to create question", js: true do
    click_link('Add Question')
    find('#remove_form').click
    expect(page).not_to have_content("Question Type:")
    expect(page).not_to have_content("Required")
  end

  def fill_in_question_text
    fill_in 'question[body]', with: "How old are you?"
  end
end