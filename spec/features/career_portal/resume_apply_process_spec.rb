require 'spec_helper'

feature 'Applies with Resume to a job', {js: true, vcr: true} do 
  background do 
    visit register_path
  end

  scenario 'with valid user info and valid card' do 
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign up"
    expect(page).to have_content("Thank you for registering with myFlix")
  end
end
