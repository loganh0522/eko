require 'spec_helper'

describe UsersController do 
  describe 'GET new' do 
    it 'sets the @user' do
      get :new 
      expect(assigns(:user)).to be_instance_of(User)
    end
  end 

  describe 'POST create' do    
    context "With valid input" do     
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "saves the new user to the database" do    
        expect(User.count).to eq(1)
      end

      it "sets the session[user_id]" do 
        session[:user_id] = Fabricate(:user).id
      end
      
      it "redirects the new user to the new company route" do 
        expect(response).to redirect_to new_company_path
      end
    end

    context "Without valid input do" do 
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
end