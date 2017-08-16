require 'spec_helper' 

describe Business::JobsController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    
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
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      get :index
    end

    context "when user belongs to current_company" do
      it "sets the @jobs to the job postings that belong to the current company" do    
        expect(assigns(:jobs)).to eq([job])
      end

      it "expects to return the correct number of job postings" do 
        expect(Job.count).to eq(1)
      end
    end
  end

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user: alice)}

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
      set_current_user(alice)
      set_current_company(company)
      get :new
    end

    it "sets the @job_posting instance" do 
      expect(assigns(:job)).to be_instance_of Job 
      expect(assigns(:job)).to be_new_record 
    end
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) {post :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {post :create}
    end
    
    context "with valid inputs" do 
      let(:company) {Fabricate(:company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job) {Fabricate.attributes_for(:job, company: company, user_ids: alice.id)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        post :create, job: job
      end

      it "redirects to the new Hiring team path" do   
        expect(response).to redirect_to new_business_job_hiring_team_path(Job.first.id)
      end
      
      it "creates the job posting" do
        expect(Job.count).to eq(1)
      end

      it "creates a scorecard associated to the Job posting" do 
        expect(Scorecard.count).to eq(1)
      end

      it "creates the stages associated to the Job posting" do 
        expect(Stage.count).to eq(6)
      end

      it "associates the job posting with the current_company" do
        expect(Job.first.company).to eq(company)
      end

      it "creates a HiringTeam association with the current user" do 
        expect(HiringTeam.first.user_id).to eq(alice.id)
      end

      it "sets the job status as a draft" do 
        expect(Job.first.status).to eq('draft')
      end

      it "sets the city, province, country attributes" do 
        expect(Job.first.city).to eq('Toronto')
        expect(Job.first.province).to eq('On')
        expect(Job.first.country).to eq('Canada')
      end
    end

    context "with invalid inputs" do 
      let(:company) {Fabricate(:company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job) {Fabricate.attributes_for(:job, company: company, user_ids: alice.id, title: "")}
      before do      
        set_current_user(alice)
        set_current_company(company)
        job_board
        post :create, job: job
      end

      it "does not create a job posting" do     
        expect(Job.count).to eq(0)
      end

      it "does not create a questionairre for the job posting" do     
        expect(Questionairre.count).to eq(0)
      end

      it "does not create a scorecard for the job posting" do     
        expect(Scorecard.count).to eq(0)
      end

      it "does not create a stage for the job posting" do     
        expect(Stage.count).to eq(0)
      end

      it "renders the new action" do 
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:job1) {Fabricate(:job, company: company)}
    let(:questionairre) {Fabricate(:questionairre, job_id: job1.id)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job1.id)}

    it_behaves_like "requires sign in" do
      let(:action) {get :edit, id: job1.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :edit, id: job1.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :edit, id: job1.id}
    end
    
    before do      
      set_current_user(alice)
      set_current_company(company)  
      job_board 
      get :edit, id: job1.id   
    end

    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job1)
    end
  end

  describe "PUT update" do 
    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job) {Fabricate(:job, company: company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job = Fabricate(:job, company: company)
        put :update, id: job.id, job: Fabricate.attributes_for(:job, title: "new title")
      end

      it_behaves_like "requires sign in" do
        let(:action) {put :update, id: job.id}
      end

      it_behaves_like "user does not belong to company" do 
        let(:action) {put :update, id: job.id}
      end

      it_behaves_like "company has been deactivated" do
        let(:action) {put :update, id: job.id}
      end

      it "save the updates made on the object" do 
        expect(Job.first.title).to eq("new title")
      end

      it "render's the hiring team page" do 
        expect(response).to redirect_to new_business_job_hiring_team_path(Job.first.id)
      end

      it "redirects_to the index page" do 
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
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

  # describe "POST publish job" do 
  #   it_behaves_like "requires sign in" do
  #     let(:action) {post :publish_job, job_id: 4}
  #   end

  #   it_behaves_like "user does not belong to company" do 
  #     let(:action) {post :publish_job, job_id: 4}
  #   end

  #   it_behaves_like "company has been deactivated" do
  #     let(:action) {post :publish_job, job_id: 4}
  #   end

  #   context "with less open jobs than paid for" do 
  #     let(:company) {Fabricate(:company, subscription: 'basic', open_jobs: 1 )}
  #     let(:alice) {Fabricate(:user, company: company)}
  #     let(:job) {Fabricate(:job, status: 'draft', company: company)}
    
  #     before do 
  #       set_current_user(alice)
  #       set_current_company(company)
  #       post :publish_job, job_id: job.id
  #     end

  #     it "sets the status of the job to open" do      
  #       expect(Job.first.status).to eq('open')
  #     end

  #     it "increments a companies open_jobs by 1" do 
  #       expect(Company.first.open_jobs).to eq(2)
  #     end
  #   end

  #   context "with maximum number of open jobs" do 
  #     let(:company) {Fabricate(:company, subscription: 'basic', open_jobs: 3 )}
  #     let(:alice) {Fabricate(:user, company: company)}
  #     let(:job) {Fabricate(:job, status: 'draft', company: company)}
    
  #     before do 
  #       set_current_user(alice)
  #       set_current_company(company)
  #       post :publish_job, job_id: job.id
  #     end

  #     it "sets the flash message of the job to open" do
  #       expect(flash[:danger]).to be_present
  #     end

  #     it "renders the edit template" do 
  #       expect(response).to render_template :edit
  #     end
  #   end
  # end

  # describe "POST close job" do 
  #   it_behaves_like "requires sign in" do
  #     let(:action) {post :close_job, job_id: 4}
  #   end

  #   it_behaves_like "user does not belong to company" do 
  #     let(:action) {post :close_job, job_id: 4}
  #   end

  #   it_behaves_like "company has been deactivated" do
  #     let(:action) {post :close_job, job_id: 4}
  #   end

  #   let(:company) {Fabricate(:company, subscription: 'basic', open_jobs: 3 )}
  #   let(:alice) {Fabricate(:user, company: company)}
  #   let(:job) {Fabricate(:job, status: 'open', company: company)}
  
  #   before do 
  #     set_current_user(alice)
  #     set_current_company(company)
  #     post :close_job, job_id: job.id
  #   end

  #   it "sets the status of the job to be closed3" do      
  #     expect(Job.first.status).to eq('closed')
  #   end

  #   it "decreases a companies open_jobs by 1" do 
  #     expect(Company.first.open_jobs).to eq(2)
  #   end
  # end
end