require 'spec_helper'

feature "creating a job posting" do 
  scenario "posts a job with out errors" do
    sign_in_business
    page.should have_content @job.title
 
    click_link('Post a Job')
    current_path == "business/jobs/new"
    fill_out_job
    click_button "Create Posting"
    current_path == "business/jobs/2/questions"

    expect(page).to have_content "Sales Representative"
    expect(page).to have_content "Toronto, On, Canada"
    expect(page).to have_content "Application Form"
  end

  # scenario "posts a job with out ERRORS PRESENT" do
  #   sign_in_business
  #   page.should have_content @job.title
  #   click_link('Post a Job')
  #   current_path == "business/jobs/new"
  #   click_button "Create Posting"
  #   current_path == "business/jobs/new"
  #   expect(page).to have_content "Sales Representative"
  #   expect(page).to have_content "Toronto, On, Canada"
  #   expect(page).to have_content "Application Form"
  # end


  def fill_out_job
    fill_in 'Job Title', with: "Sales Representative"
    fill_in_trix_editor('job_description_trix_input_job', 'You will discover treasures of Anatolia')
    fill_in "geocomplete", with: "Toronto, On, Canada"
  end
end