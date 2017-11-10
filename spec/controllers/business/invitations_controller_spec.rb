require 'spec_helper' 

describe Business::InvitationsController do 
  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :index}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:invitation) {Fabricate(:invitation, company: company)}

    before do 
      set_current_company(company)
      set_current_user(alice)
      invitation
      xhr :get, :index
    end

    it "sets the @invitations to the invitations that belong to current company" do 
      expect(assigns(:invitations)).to eq([invitation])
    end

    it "expects the response to render index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new
    end
    
    it "set @invitation to be a new instance of Invitation" do
      expect(assigns(:invitation)).to be_new_record 
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create}
    end

    context "with valid inputs" do 
      before do 
        company = Fabricate(:company)
        alice = Fabricate(:user, kind: 'business', company: company)
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, invitation: { recipient_email: "Joe@example.com", message: "message", user_role: "admin" }
      end

      it "creates the invitation" do  
        expect(Invitation.count).to eq(1)
      end

      it "redirects to the invite_user page" do 
        expect(response).to render_template :create
      end

      it "sends an email to the recipient" do 
        expect(ActionMailer::Base.deliveries.last.to).to eq(["Joe@example.com"])
      end
    end

    context "with invalid inputs" do 
      before { ActionMailer::Base.deliveries.clear }
      
      before do 
        company = Fabricate(:company)
        alice = Fabricate(:user, kind: 'business', company: company)
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, invitation: {recipient_email: nil}
      end

      it "renders the users template" do 
        expect(response).to render_template :create
      end

      it "does not create an invitation" do 
        expect(Invitation.count).to eq(0)
      end

      it "does not send an email" do 
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end