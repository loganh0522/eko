require 'spec_helper' 

describe Business::JobTemplatesController do 
  let(:company) {Fabricate(:company)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
  let(:template) {Fabricate(:job_template, company: company)}
  
  before do 
    set_current_user(alice)
    set_current_company(company)
    template
  end

  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index}
    end

    before do 
      get :index
    end

    context "when user belongs to current_company" do
      it "sets the @jobs to the job postings that belong to the current company" do    
        expect(assigns(:jobs)).to eq([template])
      end

      it "expects to return the correct number of job postings" do 
        expect(JobTemplate.count).to eq(1)
        expect(company.job_template.count).to eq(1)
      end
    end
  end

  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new}
    end

    before do  
      get :new
    end

    it "sets the @job instance" do 
      expect(assigns(:job_template)).to be_instance_of JobTemplate 
      expect(assigns(:job_template)).to be_new_record 
    end
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) { post :create, job_template: Fabricate.attributes_for(:job_template, company: company) }
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { post :create, job_template: Fabricate.attributes_for(:job_template, company: company) }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { post :create, job_template: Fabricate.attributes_for(:job_template, company: company) }
    end
    
    context "with valid inputs" do 
      let(:new_job) {Fabricate.attributes_for(:job, company: company, user_ids: alice.id)}

      before do  
        post :create, job: new_job
      end
      
      it "creates the job posting" do
        expect(JobTemplate.count).to eq(2)
      end

      it "associates the job posting with the current_company" do
        expect(JobTemplate.last.company).to eq(company)
      end
    end

    context "with invalid inputs" do 
      let(:new_job) { post :create, job_template: Fabricate.attributes_for(:job_template, company: company) }
      
      before do      
        post :create, job: new_job
      end

      it "does not create the job posting" do
        expect(JobTemplate.count).to eq(1)
      end
    end
  end

  describe "GET edit" do    
    it_behaves_like "requires sign in" do
      let(:action) {get :edit, id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :edit, id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :edit, id: job.id}
    end
    
    before do      
      get :edit, id: job.id   
    end

    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "renders the new action" do 
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {put :update, id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {put :update, id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {put :update, id: job.id}
    end

    context "with valid inputs" do
      before do  
        xhr :put, :update, id: job.id, job: {title: "new title"}
      end

      it "save the updates made on the object" do 
        expect(Job.first.title).to eq("new title")
      end

      it "render's the hiring team page" do 
        expect(response).to redirect_to business_job_hiring_teams_path(job.id)
      end
    end

    context "with invalid inputs" do
      before do  
        xhr :put, :update, id: job.id, job: {title: nil}
      end

      it "doesn't save the updates if fields invalid" do
        expect(Job.first.title).to eq(job.title) 
      end

      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end

    context "with params[:status] present && status == closed" do
      before do  
        xhr :put, :update, id: job.id, status: 'closed'
      end

      it "save the updates made on the object" do 
        expect(Job.first.status).to eq('closed')
      end

      it "render's the hiring team page" do 
        expect(response).to render_template :update
      end
    end

    context "with params[:status] present && status == publish" do
      before do  
        xhr :put, :update, id: job.id, status: 'publish'
      end

      it "save the updates made on the object" do 
        expect(Job.first.status).to eq('publish')
      end

      it "render's the hiring team page" do 
        expect(response).to render_template :update
      end
    end

    context "with params[:status] present && status == archive" do
      before do  
        xhr :put, :update, id: job.id, status: 'archive'
      end

      it "save the updates made on the object" do 
        expect(Job.first.status).to eq('archive')
      end

      it "render's the hiring team page" do 
        expect(response).to render_template :update
      end
    end
  end
end