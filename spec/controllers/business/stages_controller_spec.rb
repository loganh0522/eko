require 'spec_helper'

describe Business::StagesController do 
  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {get :new, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new, job_id: job.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      get :new, job_id: job.id
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end
    
    it "set @stage to be a new instance of Stages" do
      expect(assigns(:stage)).to be_new_record 
      expect(assigns(:stage)).to be_instance_of Stage
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:stage) {Fabricate.attributes_for(:stage)}

    it_behaves_like "requires sign in" do
      let(:action) {post :create, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create, job_id: job.id}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)
      post :create, stage: { job_id: job.id, name: "Screened", position: '1'}, job_id: job.id
    end

    it "redirects to the new action page" do 
      expect(response).to redirect_to new_business_job_stage_path(job)
    end

    it "creates the new stage" do 
      expect(Stage.count).to eq(1)
    end

    it "associates the stage with the job" do 
      expect(Stage.first.job).to eq(job)
    end

    it "adds a new stage last in the list" do 
      Fabricate(:stage, position: 1, job_id: job.id)
      expect(Stage.first.position).to eq(2)
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:stage) {Fabricate(:stage, job_id: job.id)}

    it_behaves_like "requires sign in" do
      let(:action) {get :edit, job_id: 4, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :edit, job_id: 4, id: 4}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)
      get :edit, id: stage.id, job_id: job.id
    end

     it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @stage to the stage associated with the job posting" do 
      expect(assigns(:stage)).to eq(stage)
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {put :update, job_id: 4, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {put :update, job_id: 4, id: 4}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)      
    end

    it "save the updates made on the object" do 
      stage = Fabricate(:stage, job_id: job.id)
      put :update, id: stage.id, stage: {job_id: job.id, name: "Screened"}, job_id: job.id, format: :js
      expect(Stage.first.name).to eq("Screened")
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)      
    end

    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, job_id: 4, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {delete :destroy, job_id: 4, id: 4}
    end

    it "deletes the stage" do 
      stage = Fabricate(:stage, job_id: job.id)
      delete :destroy, job_id: job.id, id: stage.id, format: :js
      expect(HiringTeam.count).to eq(0)
    end
  end

  describe "POST sort" do
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)      
    end

    it_behaves_like "requires sign in" do
      let(:action) {post :sort, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :sort, job_id: job.id}
    end

    it "reorders the items in the queue" do
      stage1 = Fabricate(:stage, position: 1, job_id: job.id) 
      stage2 = Fabricate(:stage, position: 2, job_id: job.id)
      post :sort, job_id: job.id, stage: [stage2.id, stage1.id]
      expect(stage2.reload.position).to eq(1)
    end
  end
end