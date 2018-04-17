shared_examples "requires sign in" do 
  it "redirects to the sign in page" do 
    session[:user_id] = nil 
    action 
    expect(response).to redirect_to login_path
  end
end

shared_examples "user is not a job seeker" do 
  let(:company){Fabricate(:company)}
  let(:alice){Fabricate(:user, kind: 'business', company: company, role: "Admin")}
  
  it "redirects the user to the business_root_path if logged in" do 
    set_current_user(alice)
    set_current_company(company)
    action 
    expect(response).to redirect_to business_root_path
  end
end

shared_examples "trial is over" do 
  let(:company){Fabricate(:company, active: false, subscription: "trial")}
  let(:alice){Fabricate(:user, kind: 'business', company: company, role: "Admin")}
  
  it "redirects the user to the business_plan_path" do 
    set_current_user(alice)
    set_current_company(company)
    action 
    expect(response).to redirect_to business_plan_path
  end
end

shared_examples "user does not belong to company" do 
  let(:company) {Fabricate(:company)}
  let(:company2) {Fabricate(:company)}
  let(:alice) {Fabricate(:user, kind: 'business', role: "Admin", company: company2)}
  
  before do 
    set_current_user(alice)
    set_current_company(company)
    action
  end

  it "redirects user" do    
    expect(response).to redirect_to business_root_path
  end
end

shared_examples "object does not belong to user" do 
  let(:alice) {Fabricate(:user, kind: 'job seeker')}
  
  before do 
    set_current_user(alice)
    action
  end

  it "redirects user" do    
    expect(response).to redirect_to job_seeker_root_path
  end

  it "sets the flash message " do 
    expect(flash[:error]).to be_present   
  end   
end

shared_examples "company has been deactivated" do 
  let(:company) {Fabricate(:company, active: false)}
  let(:alice) {Fabricate(:user, kind: 'business', company: company, role: "Admin")}
   
  before do 
    set_current_user(alice)
    set_current_company(company)
    action
  end

  it "redirects user" do    
    expect(response).to redirect_to business_customers_path
  end

  it "sets the flash message " do 
    expect(flash[:danger]).to be_present   
  end   
end


