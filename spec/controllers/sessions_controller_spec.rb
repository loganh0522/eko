require "spec_helper" 

describe SessionsController do 
  describe "GET new" do 
    it "renders the new template for unauthenticated users" do 
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the business root path for authenticated users"  do 
      set_current_user 
      get :new 
      expect(response).to redirect_to business_root_path
    end
  end

  describe "POST create" do 
    context "with valid inputs" do 
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do 
        post :create, email: alice.email, password: alice.password 
      end

      it "puts the signed in user into the session" do 
        expect(session[:user_id]).to eq(alice.id)
      end

      it "puts the company the signed in user belongs to into the session" do 
        expect(session[:company_id]).to eq(company.id)
      end

      it "redirects the user to the business_root_path" do
        expect(response).to redirect_to business_root_path
      end

      it "sets the flash notice" do
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do 
        post :create, email: alice.email, password: alice.password + "dskfskf"
      end

      it "renders the new tempalte" do 
        expect(response).to render_template :new 
      end

      it "sets the flash message" do 
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}

    before do 
      set_current_user(alice)
      set_current_company(company)
      get :destroy
    end

    it "sets the session[user_id] to nil" do 
      expect(session[:user_id]).to be_nil
    end

    it "sets the session[company_id] to nil" do
      expect(session[:company_id]).to be_nil
    end

    it "redirect_to the login_path" do 
      expect(response).to redirect_to login_path
    end
  end
end