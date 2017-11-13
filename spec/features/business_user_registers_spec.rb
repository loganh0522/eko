require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do 
  background do 
    visit register_path
  end

  scenario 'with valid user info and valid card' do 
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign up"
    expect(page).to have_content("Thank you for registering with myFlix")
  end

  scenario 'with valid user info and invalid card' do 
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with valid user info and declined card' do 
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign up"
    expect(page).to have_content("Your card was declined.")
  end

  scenario 'with invalid user info and valid card' do 
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign up"
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end

  scenario 'with invalid user info and invalid card' do 
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with invalid user info and declined card' do 
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign up"
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end

  def fill_in_valid_user_info 
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "john@example.com"
  end
end

