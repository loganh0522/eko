require 'spec_helper' 

describe Business::JobsController do 
  let(:company) {Fabricate(:company)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
  let(:job) {Fabricate(:job, company: company, user_ids: alice.id, status: "open", is_active: true)}
  let(:job2) {Fabricate(:job, company: company, user_ids: alice.id, status: "open", is_active: true)}
  let(:questionairre) {Fabricate(:questionairre, job_id: job1.id)}
  let(:scorecard) {Fabricate(:scorecard, job_id: job1.id)}

  before do 
    set_current_user(alice)
    set_current_company(company)
    job_board
    job
    job2
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
        expect(assigns(:jobs)).to eq([job, job2])
      end

      it "expects to return the correct number of job postings" do 
        expect(Job.count).to eq(2)
        expect(company.jobs.count).to eq(2)
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

    it_behaves_like "company has been deactivated" do
      let(:action) {get :new}
    end

    before do  
      get :new
    end

    it "sets the @job instance" do 
      expect(assigns(:job)).to be_instance_of Job 
      expect(assigns(:job)).to be_new_record 
    end
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) { post :create, job: Fabricate.attributes_for(:job, company: set_current_company, user_ids: set_current_user) }
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { post :create, job: Fabricate.attributes_for(:job, company: set_current_company, user_ids: set_current_user) }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { post :create, job: Fabricate.attributes_for(:job, company: set_current_company, user_ids: set_current_user) }
    end
    
    context "with valid inputs" do 
      let(:new_job) {Fabricate.attributes_for(:job, company: company, user_ids: alice.id)}

      before do  
        post :create, job: new_job
      end

      it "redirects to the new Hiring team path" do   
        expect(response).to redirect_to business_job_hiring_teams_path(Job.last.id)
      end
      
      it "creates the job posting" do
        expect(Job.count).to eq(3)
      end

      it "creates a job_Feed associated to the Job posting" do 
        expect(Job.first.job_feed).to be_present
      end

      it "creates the stages associated to the Job posting" do 
        expect(Stage.count).to eq(15)
        expect(Job.first.stages.count).to eq(5)
      end

      it "associates the job posting with the current_company" do
        expect(Job.first.company).to eq(company)
      end

      it "creates a HiringTeam association with the current user" do 
        expect(HiringTeam.first.user_id).to eq(alice.id)
      end

      it "sets the job status as a draft" do 
        expect(Job.last.status).to eq('open')
      end

      it "sets the city, province, country attributes" do 
        expect(Job.first.city).to eq('Toronto')
        expect(Job.first.province).to eq('On')
        expect(Job.first.country).to eq('Canada')
      end
    end

    context "with invalid inputs" do 
      let(:new_job) {Fabricate.attributes_for(:job, company: company, user_ids: alice.id, title: "")}
      
      before do      
        post :create, job: new_job
      end

      it "does not create a job posting" do     
        expect(Job.count).to eq(2)
      end

      it "does not create a scorecard for the job posting" do     
        expect(Scorecard.count).to eq(0)
      end

      it "does not create a stage for the job posting" do     
        expect(Stage.count).to eq(10)
      end

      it "renders the new action" do 
        expect(response).to render_template :new
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