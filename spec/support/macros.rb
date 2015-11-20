def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_company(company=nil)
  session[:company_id] = (company || Fabricate(:company)).id
end