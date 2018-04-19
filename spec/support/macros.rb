def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_company(company=nil)
  session[:company_id] = (company || Fabricate(:company)).id
end

def create_data_for_business
  @company = Fabricate(:company)
  @alice = Fabricate(:user, company: @company, role: 'Admin', kind: 'business')
  @eric = Fabricate(:user, company: @company, role: 'Admin', kind: 'business')
  @bryan = Fabricate(:user, company: @company, role: 'Admin', kind: 'business')
  @job = Fabricate(:job, company: @company, users: [@alice])
end

def sign_in_business
  create_data_for_business
  visit login_path
  fill_in "E-mail", with: @alice.email
  fill_in "Password", with: @alice.password
  click_button "Sign In"
end


def sign_in_job_seeker(a_user = nil)
  a_user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "E-mail Address", with: a_user.email
  fill_in "Password", with: a_user.password
  click_button "Sign in"
end

def sign_out 
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end



