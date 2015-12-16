shared_examples "requires sign in" do 
  it "redirects to the sign in page" do 
    session[:user_id] = nil 
    action 
    expect(response).to redirect_to login_path
  end
end

shared_examples "user does not belong to company" do 
  let(:alice) {Fabricate(:user)}
  let(:company) {Fabricate(:company)}
  
  before do 
    set_current_user(alice)
    set_current_company(company)
  end

  it "redirects user" do    
    action
    expect(response).to redirect_to login_path
  end

  it "sets the flash message " do 
    action
    expect(flash[:error]).to be_present   
  end   
end

