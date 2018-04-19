require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do 
  background do 
    visit register_path
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

