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
        post :create, company: {name: "Talentwiz", location: "Toronto, On, Canada", size: "50-200", website: "www.talentwiz.ca", users_attributes: {"0"=>{first_name: "Logan", last_name: "Houston", email: "houston@talentwiz.ca", password: "password"}}}
      end

      it "creates the company" do         
        expect(Company.count).to eq(1)
      end

      it "creates the EmailSignature for the user " do 
        expect(EmailSignature.count).to eq(1)
        expect(User.first.email_signature).to be_present
      end

      it "creates the stages, rejection_Reasons, applicationEmail, JobBoard for the company" do 
        expect(DefaultStage.count).to eq(6)
        expect(RejectionReason.count).to eq(7)
        expect(JobBoard.count).to eq(1)
        expect(Company.first.job_board).to be_present
        expect(Company.first.rejection_reasons.count).to eq(7)
        expect(Company.first.default_stages.count).to eq(6)
        expect(Company.first.default_stages.count).to eq(6)
      end

      it "creates the application_email for the company" do 
        expect(ApplicationEmail.count).to eq(1)
        expect(Company.first.application_email.body).to eq("We appreciate your application for the {{job.title}}, we will be in touch with you soon.")
        expect(Company.first.application_email).to be_present
      end

      it "creates a user that belongs to the company" do 
        expect(User.first.company).to eq(Company.first)
        expect(User.first.kind).to eq('business')
        expect(User.first.role).to eq('Admin')
      end
        
      it 'sets the session for the company and user' do 
        expect(session[:company_id]).to eq(Company.first.id)
        expect(session[:user_id]).to eq(User.first.id)
      end

      it 'redirects the user to the root path' do
        expect(response).to redirect_to business_root_path
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

