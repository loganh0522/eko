require 'spec_helper'

describe Business::HiringTeamsController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:joe) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    
    before do 
      set_current_company(company)
      set_current_user(alice)
      job_board
      job
      joe
      @job_member = Fabricate(:hiring_team, job: job, user: alice)
      get :index, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index, job_id: job.id}
    end

    it "sets the @users to the users that belong to current company" do 
      expect(assigns(:users)).to eq([alice, joe])
    end

    it "sets the @team to the users that belong to the job" do 
      expect(assigns(:team)).to eq([@job_member])
    end

    it "sets the @job to be the correct instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end

    it "expects the response to render index template" do
      expect(response).to render_template :index
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:joe) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    
    before do 
      set_current_company(company)
      set_current_user(alice)
      job_board
      job
      joe
      @job_member = Fabricate(:hiring_team, job_id: job.id, user_id: alice.id)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, user_id: joe.id, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, user_id: joe.id, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, user_id: joe.id, job_id: job.id}
    end

    context "User is not a part of Hiring Team" do
      before do 
        xhr :post, :create, user_id: joe.id, job_id: job.id
      end

      it "adds a user to the jobs hiring team" do 
        expect(job.users.count).to eq(2)
      end

      it "adds the selected users to the job" do 
        expect(job.users.last).to eq(joe)
      end

      it "sets the @users to the users that belong to current company" do 
        expect(assigns(:job)).to eq(job)
      end

      it "sets the @users to the users that belong to current company" do 
        expect(assigns(:team)).to eq([@job_member, HiringTeam.last])
      end

      it "expects the response to render index template" do
        expect(response).to render_template :create
      end
    end

    context "user already part of Hiring Team" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:joe) {Fabricate(:user, company: company)}
      let(:job) {Fabricate(:job, company: company)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        job_board
        job
        joe 
        xhr :post, :create, user_id: alice.id, job_id: job.id
      end

      it "does not add user" do 
        expect(Job.first.users.count).to eq(1)
      end

      it "expects the response to render index template" do
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:joe) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      joe
      @job_member = Fabricate(:hiring_team, job: job, user: alice)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: @job_member.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, id: @job_member.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, id: @job_member.id}
    end
    
    context "it has multiple team members on the job" do 
      before do 
        @job_member2 = Fabricate(:hiring_team, job: job, user: joe)
        xhr :delete, :destroy, id: @job_member.id
      end

      it "deletes the selected user from the hiring team" do  
        expect(HiringTeam.count).to eq(1)
      end

      it "expects the response to render index template" do
        expect(response).to render_template :destroy
      end
    end

    context "it has DOES NOT have multiple team members on the job" do
       before do 
        xhr :delete, :destroy, id: @job_member.id
      end

      it "does not delete the selected user from the hiring team" do  
        expect(HiringTeam.count).to eq(1)
      end

      it "expects the response to render index template" do
        expect(response).to render_template :destroy
      end
    end
  end
end