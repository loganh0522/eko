require 'spec_helper' 

describe JobPostingsController do 
  describe "GET index" do 
    context "when user belongs to current_company" do
      it_behaves_like "requires sign in" do
        let(:action) {get :index}
      end

      it_behaves_like "user does not belong to company" do 
        let(:action) {get :index}
      end

      it "sets the @jobs to the job postings that belong to the current company" do 
        company = Fabricate(:company)
        alice = Fabricate(:user, company: company)
        set_current_user(alice)
        set_current_company(company)
        sales_rep1 = Fabricate(:job_posting, company: company) 
        sales_rep2 = Fabricate(:job_posting) 
        get :index
        expect(assigns(:jobs)).to eq([sales_rep1])
      end
    end
  end

  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it "sets the @job_posting instance" do 
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      get :new 
      expect(assigns(:job_posting)).to be_instance_of(JobPosting)
    end
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end
    
    context "with valid inputs" do 
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        get :create, job_posting: Fabricate.attributes_for(:job_posting), company: company
      end

      it "redirects to the index" do   
        expect(response).to redirect_to job_postings_path
      end
      
      it "creates the job posting" do
        expect(JobPosting.count).to eq(1)
      end

      it "associates the job posting with the current_company" do
        expect(JobPosting.first.company).to eq(company)
      end

      it "sets the flash message" do 
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do 
      let(:company) {Fabricate(:company)}
      let(:alice ) {Fabricate(:user, company: company)}

      before do      
        set_current_user(alice)
        set_current_company(company)
        get :create, job_posting: {title: "Sales Rep"}
      end

      it "does not create a job posting" do     
        expect(JobPosting.count).to eq(0)
      end

      it "renders the new action" do 
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it "sets @job_posting to the correct job posting" do 
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      job = Fabricate(:job_posting)
      get :edit, id: job.id
      expect(assigns(:job_posting)).to eq(job)
    end
  end


end