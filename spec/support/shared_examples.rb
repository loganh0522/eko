shared_examples "requires sign in" do 
  it "redirects to the sign in page" do 
    session[:user_id] = nil 
    action 
    expect(response).to redirect_to login_path
  end
end

shared_examples "user does not belong to company" do 
  it "redirects user" do 
    alice = Fabricate(:user)
    set_current_user(alice)
    company = (Fabricate(:company))
    set_current_company(company)
    action
    expect(response).to redirect_to login_path
  end

  it "sets the flash message " do 
    alice = Fabricate(:user)
    set_current_user(alice)
    company = (Fabricate(:company))
    set_current_company(company)
    action
    expect(flash[:error]).to be_present   
  end   
end

