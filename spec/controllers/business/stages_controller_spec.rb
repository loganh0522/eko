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
      post :create, stage: stage, job_id: job.id
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

  describe "POST sort" do 
    it "reorders the items in the queue"
    it "does not render anything"
  end
end