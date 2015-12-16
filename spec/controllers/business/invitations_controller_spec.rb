require 'spec_helper' 

describe Business::InvitationsController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new}
    end

    it "sets the invitation to a new instance" do
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      get :new 
      expect(assigns(:invitation)).to be_instance_of(Invitation)
      expect(assigns(:invitation)).to be_new_record 
    end
  end

  describe "POST create" do 
    it_behaves_like "requires sign in" do 
      let(:action) {post :create} 
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create} 
    end

    context "with valid inputs" do  
      it "creates the invitation"
      it "redirects to the invite new user page"
      it "sends an email to the recipient"
      it "sets the flash success message"
    end

    context "with invalid inputs" do 
      it "renders the new template"
      it "does not create an invitation" 
      it "does not send an email"
      it "sets the flash error message"
    end
  end
end