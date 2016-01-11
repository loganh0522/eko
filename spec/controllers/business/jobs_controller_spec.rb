require 'spec_helper' 

describe Business::JobsController do 
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
        sales_rep1 = Fabricate(:job, company: company) 
        sales_rep2 = Fabricate(:job) 
        get :index
        expect(assigns(:jobs)).to eq([sales_rep1])
      end
    end
  end

  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new}
    end

    it "sets the @job_posting instance" do 
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      get :new 
      expect(assigns(:job)).to be_instance_of(Job)
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
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job) {Fabricate.attributes_for(:job)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        post :create, job: job , company: company, user_ids: alice.id
      end

      it "redirects to the edit Hiring team path" do   
        expect(response).to redirect_to new_business_job_hiring_team_path(job)
      end
      
      it "creates the job posting" do
        expect(Job.count).to eq(1)
      end

      it "associates the job posting with the current_company" do
        expect(Job.first.company).to eq(company)
      end

      it "creates a HiringTeam association with the current user" do 
        expect(Job.first.user_ids).to eq([alice.id])
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
        post :create, job: {title: "Sales Rep"}
      end

      it "does not create a job posting" do     
        expect(Job.count).to eq(0)
      end

      it "renders the new action" do 
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :edit, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :edit, id: 4}
    end

    it "sets @job to the correct job posting" do 
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      job1 = Fabricate(:job)
      get :edit, id: job1.id
      expect(assigns(:job)).to eq(job1)
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {put :update, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {put :update, id: 4}
    end

    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        job1 = Fabricate(:job, company: company)
        put :update, id: job1.id, job: Fabricate.attributes_for(:job, title: "new title")
      end

      it "save the updates made on the object" do 
        expect(Job.first.title).to eq("new title")
      end

      it "redirects_to the index page" do 
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        job1 = Fabricate(:job, title: "old title", company: company)
        put :update, id: job1.id, job: Fabricate.attributes_for(:job, title: nil)
      end

      it "doesn't save the updates if fields invalid" do
        expect(Job.first.title).to eq("old title") 
      end

      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end
  end
end