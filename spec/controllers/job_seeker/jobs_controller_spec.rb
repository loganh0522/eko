require 'spec_helper'

describe JobSeeker::JobsController do 
  describe "GET index" do 
    it_behaves_like "requires sign in" do 
      let(:action) {get :index} 
    end

    it_behaves_like "user is not a job seeker" do
      let(:action) {get :index}
    end

    it "sets the @jobs instance, to all the jobs in database" do
      alice = Fabricate(:user, kind: 'job seeker')
      set_current_user(alice)
      job1 = Fabricate(:job)
      job2 = Fabricate(:job)
      get :index
      expect(assigns(:jobs)).to match_array([job1, job2])
    end
  end

  describe "GET show" do 
    it_behaves_like "requires sign in" do 
      let(:action) {get :index} 
    end

    it_behaves_like "user is not a job seeker" do
      let(:action) {get :index}
    end

    it "sets the @job instance to the specific job posting" do
      alice = Fabricate(:user, kind: 'job seeker')
      set_current_user(alice)
      job = Fabricate(:job)
      get :show, id: job.id
      expect(assigns(:job)).to eq(job)
    end
  end
end