require 'spec_helper'

describe CompaniesController do 
  describe 'GET new' do 
    it "should set @company" do
      get :new 
      expect(assigns(:company)).to be_instance_of(Company)
    end
  end

  describe 'POST create' do 
    context 'if valid' do 
      before do 
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        current_user = User.find(session[:user_id])
        post :create, company: Fabricate.attributes_for(:company)
      end

      it "creates the company" do         
        expect(Company.count).to eq(1)
      end

      it "sets the current_user's company_id" do 
        expect(User.first.company).to eq(Company.first)
      end
        
      it 'sets the session for the company' do 
        expect(session[:company_id]).to eq(Company.first.id)
      end

      it 'redirects the user to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'if invalid' do 
      before do 
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        current_user = User.find(session[:user_id])
        post :create, company: {website: "www.example.com"}
      end

      it "does not create the company" do 
        expect(Company.count).to eq(0)
      end

      it "renders to the create_company_path" do 
        expect(response).to render_template :new
      end

      it "sets the @company instance" do 
        expect(assigns(:company)).to be_instance_of(Company) 
      end
    end
  end
end

