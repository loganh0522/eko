require 'spec_helper'

describe Business::ApplicationScorecardsController do 
  describe "GET index" do     
    it_behaves_like "requires sign in" do
      let(:action) {get :index, job_id: 4, application_id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index, job_id: 4, application_id: 4}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index, job_id: 4, application_id: 4}
    end
    
    context "with valid inputs" do
      let(:talentwiz) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, kind: "business", company: talentwiz)}
      let(:job) {Fabricate(:job, company: talentwiz)}
      let(:stage) {Fabricate(:stage, job: job)}
      let(:application) {Fabricate(:application, job_id: job.id, company: talentwiz, stage_id: stage.id)}  
      # let(:scorecard) {Fabricate(:scorecard, job_id: job.id)} 
      # let(:scorecard_section) {Fabricate(:scorecard_section, scorecard_id: scorecard.id, body: "Skills")}
      # let(:section_option) {Fabricate(:section_option, scorecard_section_id: scorecard_section.id, body: "Rails")}

      before do  
        set_current_user(alice)
        set_current_company(talentwiz)     
        get :index, job_id: job.id, application_id: application.id
      end
      
      it "sets @application_scorecard to be new instance" do 
        expect(assigns(:application_scorecard)).to be_instance_of(ApplicationScorecard)
        expect(assigns(:application_scorecard)).to be_new_record 
      end

      it "sets @job to the correct instance of the job" do 
        expect(assigns(:job)).to eq(job)
      end

      it "sets @application to the correct instance of the job" do 
        expect(assigns(:application)).to eq(application)
      end

      it "sets @stage to the proper stage of the application" do 
        expect(assigns(:stage)).to eq(stage)
      end

      it "sets @comment to be a new instance" do 
        expect(assigns(:comment)).to be_instance_of(Comment)
        expect(assigns(:comment)).to be_new_record 
      end

    # it "sets the scorecard to the correct instance that belongs to the job" do 
    #   binding.pry
    #   expect(assigns(:scorecard)).to eq(scorecard)
    # end
    end
  end
end