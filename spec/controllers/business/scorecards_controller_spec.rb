require 'spec_helper'

describe Business::ScorecardsController do 
  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    
    before do  
      set_current_user(alice)
      set_current_company(company)
      Fabricate(:questionairre, job: job)
      get :new, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :new, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new, job_id: job.id}
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets the @scorecard to the jobs scorecard" do 
      expect(assigns(:questionairre)).to eq(job.questionairre)
    end
    
    it "sets @scorecard to be a new instance of Scorecard" do
      expect(assigns(:scorecard)).to be_new_record 
      expect(assigns(:scorecard)).to be_instance_of Scorecard
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job.id)}
   
    
    it_behaves_like "requires sign in" do
      let(:action) {post :create, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create, job_id: job.id}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)
      post :create, scorecard: scorecard, job_id: job.id
    end

    it "creates the scorecard" do 
      expect(Scorecard.count).to eq(1)
    end

    it "associates the scorecard with the job" do 
      expect(Scorecard.first.job).to eq(job)
    end
  end

  describe "GET edit" do
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job.id)}

    it_behaves_like "requires sign in" do
      let(:action) {get :edit, job_id: 2, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :edit, job_id: 2, id: 4}
    end
    
    before do      
      set_current_user(alice)
      set_current_company(company)   
      get :edit, id: scorecard.id, job_id: job.id  
    end

    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @questionairre to the correct job posting" do 
      expect(assigns(:scorecard)).to eq(scorecard)
    end
  end
end