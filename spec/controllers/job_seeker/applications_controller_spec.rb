require 'spec_helper'

describe JobSeeker::ApplicationsController do 
  describe 'POST create' do
    it_behaves_like "requires sign in" do 
      let(:action) {post :create} 
    end

    it_behaves_like "user is not a job seeker" do
      let(:action) {post :create}
    end

    context "application does not exist" do
      let(:alice) {Fabricate(:user, kind: 'job seeker')}
      let(:company) {Fabricate(:company)}
      let(:job1) {Fabricate(:job, company: company)}
      
      before do  
        set_current_user(alice)
        post :create, application: {user_id: alice.id, job_id: job1.id}
      end

      it "creates a new application" do 
        expect(Application.count).to eq(1)
      end

      it "associates the application to the current job seeker" do 
        expect(Application.first.user_id).to eq(alice.id)
      end

      it "associates the application to the job posting" do 
        expect(Application.first.job_id).to eq(job1.id)
      end

      it "sets the flash message" do
        expect(flash[:success]).to be_present
      end

      it "redirects the user to the job board" do 
        expect(response).to redirect_to job_seeker_jobs_path
      end
    end

    context "application already exists" do
      let(:alice) {Fabricate(:user, kind: 'job seeker')}
      let(:company) {Fabricate(:company)}
      let(:job1) {Fabricate(:job, company: company)}
      
      before do  
        set_current_user(alice)
        Fabricate(:application, user_id: alice.id, job_id: job1.id)
        post :create, application: {user_id: alice.id, job_id: job1.id}
      end
      
      it "does not create a new application" do  
        expect(Application.count).to eq(1)
      end

      it "sets the flash message" do 
        expect(flash[:error]).to be_present
      end

      it "redirects to the show job action" do 
        expect(response).to redirect_to job_seeker_jobs_path
      end
    end
  end
end