require 'spec_helper' 

describe Business::InvitationsController do 

  describe "POST create" do 
    it_behaves_like "requires sign in" do 
      let(:action) {post :create} 
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create} 
    end

    context "with valid inputs" do 
      before do 
        company = Fabricate(:company)
        alice = Fabricate(:user, company: company)
        set_current_user(alice)
        set_current_company(company)
        post :create, invitation: { recipient_email: "Joe@example.com" }
      end

      it "creates the invitation" do  
        expect(Invitation.count).to eq(1)
      end

      it "redirects to the invite_user page" do 
        expect(response).to redirect_to business_users_path
      end

      it "sends an email to the recipient" do 
        expect(ActionMailer::Base.deliveries.last.to).to eq(["Joe@example.com"])
      end

      it "sets the flash success message" do 
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do 
      before { ActionMailer::Base.deliveries.clear }
      
      before do 
        company = Fabricate(:company)
        alice = Fabricate(:user, company: company)
        set_current_user(alice)
        set_current_company(company)
        post :create, invitation: {recipient_email: nil}
      end

      it "renders the users template" do 
        expect(response).to redirect_to business_users_path
      end

      it "does not create an invitation" do 
        expect(Invitation.count).to eq(0)
      end

      it "does not send an email" do 
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash error message" do 
        expect(flash[:error]).to be_present
      end
    end
  end
end