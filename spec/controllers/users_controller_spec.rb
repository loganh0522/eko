require 'spec_helper'

describe UsersController do 
  describe "GET new" do  
    it "sets @user" do 
      get :new 
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do    
    context "With valid input and no token" do  
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "saves the new user to the database" do    
        expect(User.count).to eq(1)
      end

      it "sets the session[user_id]" do 
        expect(session[:user_id]).to eq(User.first.id)
      end
      
      it "redirects the new user to the new company route" do 
        expect(response).to redirect_to new_company_path
      end
    end

    context "With valid input and token" do  
      let(:company) {Fabricate(:company)}
      let(:invitation) {Fabricate(:invitation, company_id: company.id)}

      before do
        post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
      end

      it "saves the new user to the database" do    
        expect(User.count).to eq(1)
      end

      it "sets the company the user belongs to" do 
        expect(User.first.company_id).to eq(company.id)
      end
      
      it "redirects the new user to the login path" do 
        expect(response).to redirect_to login_path
      end
    end

    context "Without valid input" do 
      before do 
        post :create, user: {first_name: "logan"}
      end

      it "does not create the user" do 
        expect(User.count).to eq(0)
      end

      it "renders the new user page" do 
        expect(response).to render_template :new
      end

      it "set the @user" do 
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe 'GET new_with_invitation_token' do 
    it "renders the new template" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets the invitation_token" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "sets the @user email" do 
      invitation = Fabricate(:invitation) 
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "redirects user with an invalid token" do 
      invitation = Fabricate(:invitation) 
      get :new_with_invitation_token, token: "12343"
      expect(response).to redirect_to expired_token_path
    end
  end
end