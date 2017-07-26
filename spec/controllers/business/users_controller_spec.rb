require 'spec_helper' 

describe Business::UsersController do 
  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:bro) {Fabricate(:user)}

    before do 
      set_current_company(company)
      set_current_user(alice)
      get :index
    end

    it "sets the @users to the users that belong to current company" do 
      expect(assigns(:users)).to eq([alice, joe])
    end

    it "expects the response to render index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET show" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :show}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :show}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:signature) {Fabricate(:email_signature, user_id: alice.id)}

    before do 
      set_current_company(company)
      set_current_user(alice)
    end

    it "sets the @user to the current_user" do 
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it "sets the @email_signature to current_users email signature" do
      get :show, id: alice.id
      expect(assigns(:signature)).to eq(alice.email_signature)
    end

    it "expects the response to render show template" do
      get :show, id: alice.id
      expect(response).to render_template :show
    end

    it "redirects the user to the sign in page if unauthenticated user" do
      get :show, id: joe.id
      expect(response).to redirect_to business_root_path
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:signature) {Fabricate(:email_signature, user: alice)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: joe.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: joe.id}
    end
    
    before do 
      set_current_company(company)
      set_current_user(alice)
    end

    it "sets the @user to the current_user" do 
      xhr :get, :edit, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it "expects the response to render edit template" do
      xhr :get, :edit, id: alice.id
      expect(response).to render_template :edit
    end

    it "redirects the user to the sign in page if unauthenticated user" do
      xhr :get, :edit, id: joe.id
      expect(response).to redirect_to business_root_path
    end
  end

  describe "POST update" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin", email: 'email')}
    let(:joe) {Fabricate(:user, company: company)}
    let(:signature) {Fabricate(:email_signature, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: joe.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: joe.id}
    end

    before do 
      set_current_company(company)
      set_current_user(alice)
    end

    it "redirects the user to the sign in page if unauthenticated user" do
      xhr :get, :edit, id: joe.id
      expect(response).to redirect_to business_root_path
    end

    context "with valid inputs" do
      before do  
        xhr :put, :update, id: alice.id, user: {first_name: "new@email.com",
          last_name: alice.last_name, email: alice.email}
      end

      it "save the updates made on the object" do 
        expect(User.first.first_name).to eq("new@email.com")
      end

      it "render's the update action" do 
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do  
        xhr :put, :update, id: alice.id, :user => {email: nil}
      end

      it "doesn't save the updates if fields invalid" do
        expect(User.first.email).to eq('email') 
      end
    end
  end
end