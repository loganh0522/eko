require 'spec_helper'

describe Business::HiringTeamsController do 
  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:alice) {Fabricate(:user, company: company)}

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

    it "sets @HiringTeam to be a new instance" do 
      expect(assigns(:hiring_team)).to be_new_record 
      expect(assigns(:hiring_team)).to be_instance_of HiringTeam
    end

    it "sets @Invitation to be a new instance" do 
      expect(assigns(:invitation)).to be_new_record 
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets the @users to the current hiring team" do 
      expect(assigns(:users)).to eq(job.users)
    end

    it "sets the @company_users to the current_company.users" do 
      expect(assigns(:company_users)).to eq(company.users)
    end

    it "sets the @users to the current hiring team" do 
      expect(assigns(:questionairre)).to eq(job.questionairre)
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    

    it_behaves_like "requires sign in" do
      let(:action) {post :create, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create, job_id: job.id}
    end

    context "User is not a part of Hiring Team" do
      before do 
        set_current_user(alice)
        set_current_company(company)
        
        post :create, hiring_team: { user_tokens: alice.id}, job_id: job.id
      end

      it "adds a user to the jobs hiring team" do 
        expect(job.users.count).to eq(1)
      end

      it "adds the selected users to the job" do 
        expect(job.users.last).to eq(alice)
      end
    end

    context "user already part of Hiring Team" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:joe) {Fabricate(:user, company: company)}
      let(:job) {Fabricate(:job, company: company)}

      before do 
        set_current_user(alice)
        set_current_company(company)
        Fabricate.create(:hiring_team, job_id: job.id, user_id: alice.id)
        Fabricate.create(:hiring_team, job_id: job.id, user_id: joe.id)
        post :create, hiring_team: { user_tokens: alice.id}, job_id: job.id
      end

      it "does not add user" do 
        expect(Job.first.users.count).to eq(2)
      end

      it "redirects to the new page" do 
        expect(response).to redirect_to new_business_job_hiring_team_path(job.id)
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:joe) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, job_id: 4, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {delete :destroy, job_id: 4, id: 4}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)
    end

    it "deletes the selected user from the hiring team" do  
      member = Fabricate(:hiring_team, job_id: job.id, user_id: alice.id)
      delete :destroy, job_id: job.id, id: alice.id
      expect(HiringTeam.count).to eq(0)
    end
  end
end