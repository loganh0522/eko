require 'spec_helper'

describe Business::ApplicationsController do 
  let(:company) {Fabricate(:company)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
  let(:job1) {Fabricate(:job, company: company, user_ids: alice.id)}
  let(:candidate) {Fabricate(:candidate, company: company, manually_created: true)}
  let(:candidate1) {Fabricate(:candidate, company: company, manually_created: true)}
  let(:candidate2) {Fabricate(:candidate, company: company, manually_created: true)}
  let(:application) {Fabricate(:application, job_id: job.id, candidate_id: candidate.id)}
  let(:application1) {Fabricate(:application, job_id: job.id, candidate_id: candidate1.id)}
  let(:application2) {Fabricate(:application, job_id: job.id, candidate_id: candidate2.id)}
  let(:reason) {Fabricate(:rejection_reason, company: company )}
  let(:stage) {Fabricate(:stage, job: job)}
  let(:question) {Fabricate(:question, job: job)}
  let(:question2) {Fabricate(:question, job: job)}
  
  before do 
    set_current_user(alice)
    set_current_company(company)
    job_board
    job
    stage
    candidate
    candidate1
    candidate2
    application
    application1
    application2
    question
    question2
  end

  describe "GET index" do 
    before do 
      get :index, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index, job_id: job.id}
    end

    it "sets the @jobs to the job postings that belong to the current company" do    
      expect(assigns(:job)).to eq(job)
      expect(assigns(:tags)).to match_array([])
    end

    it "expects to return the correct number of job postings" do 
      expect(assigns(:candidates).count).to eq(3)
      expect(assigns(:candidates)).to match_array([candidate, candidate1, candidate2])
    end
  end

  describe "GET show" do
    before do 
      xhr :get, :show, id: application.id, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end 
    
    it "sets the @application to application" do 
      expect(assigns(:candidate)).to eq(candidate)
      expect(assigns(:application)).to eq(application)
      expect(assigns(:job)).to eq(job)
      expect(assigns(:rejection_reasons)).to eq(company.rejection_reasons)
    end
  end

  describe "GET new" do  
    before do 
      xhr :get, :new, candidate_id: candidate.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, candidate_id: candidate.id}
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:candidate)).to eq(candidate)
    end
    
    it "set @question to be a new instance of Questions" do
      expect(assigns(:application)).to be_new_record 
      expect(assigns(:application)).to be_instance_of Application
    end
  end

  describe "POST create" do     
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, application: {job_id: job1.id, candidate_id: candidate.id} }
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, application: {job_id: job1.id, candidate_id: candidate.id} }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create, application: {job_id: job1.id, candidate_id: candidate.id} }
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, application: {job_id: job1.id, candidate_id: candidate.id} }
    end

    context "with valid input" do 
      before do 
        xhr :post, :create, application: {job_id: job1.id, candidate_id: candidate.id} 
      end

      it "creates the question" do 
        expect(Application.count).to eq(4)
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end
    end
  end

  describe "POST create_multiple" do     
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create_multiple, application: {job_id: job1.id}, applicant_ids: "#{candidate.id}"}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create_multiple, application: {job_id: job1.id}, applicant_ids: "#{candidate.id}"}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create_multiple, application: {job_id: job1.id}, applicant_ids: "#{candidate.id}"}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create_multiple, application: {job_id: job1.id}, applicant_ids: "#{candidate.id}"}
    end

    before do 
      xhr :post, :create_multiple, application: {job_id: job1.id}, applicant_ids: "#{candidate.id}"
    end

    it "creates the question" do 
      expect(Application.count).to eq(4)
    end

    it "renders the create template" do
      expect(response).to render_template :create_multiple
    end
  end

  describe "POST move_stage" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :move_stage}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :move_stage }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :move_stage}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :move_stage}
    end

    context "with applicant_ids in params" do 
      before do 
        xhr :post, :move_stage, stage: stage.id, applicant_ids: "#{candidate.id},#{candidate2.id}", job: job.id
      end

      it "moves the applcation to the appropriate stage" do 
        expect(Application.first.stage).to eq(stage)
        expect(Application.last.stage).to eq(stage)
      end

      it "expects to return the correct number of candidates" do 
        expect(assigns(:candidates)).to match_array([candidate, candidate1, candidate2])
      end

      it "expects to assign stage to the right stage" do 
        expect(assigns(:stage)).to eq(stage)
      end

      it "expects to assign job to the right job" do 
        expect(assigns(:job)).to eq(job)
      end

      it "renders the create template" do
        expect(response).to render_template :move_stage
      end
    end

    context "with one application in params" do 
      before do 
        xhr :post, :move_stage, stage: stage.id, application_id: application.id
      end

      it "creates the question" do 
        expect(Application.first.stage).to eq(stage)
      end

      it "expects to assign job to the right job" do 
        expect(assigns(:job)).to eq(job)
      end

      it "expects to return the correct number of candidate" do 
        expect(assigns(:candidates)).to match_array([candidate, candidate1, candidate2])
      end

      it "expects to assign stage to the right stage" do 
        expect(assigns(:stage)).to eq(stage)
      end

      it "renders the create template" do
        expect(response).to render_template :move_stage
      end
    end
  end

  describe "POST reject" do 
    # it_behaves_like "requires sign in" do
    #   let(:action) {xhr :post, :reject, candidate_id: candidate.id, job: job.id}
    # end

    # it_behaves_like "user does not belong to company" do 
    #   let(:action) {xhr :post, :reject, candidate_id: candidate.id, job: job.id}
    # end

    # it_behaves_like "company has been deactivated" do
    #   let(:action) {xhr :post, :reject, candidate_id: candidate.id, job: job.id}
    # end

    # it_behaves_like "trial is over" do 
    #   let(:action) {xhr :post, :reject, candidate_id: candidate.id, job: job.id}
    # end

    # context "with applicant_ids in params" do 
    #   before do 
    #     xhr :post, :reject, candidate: candidate.id, job: job.id
    #   end

    #   it "moves the applcation to the appropriate stage" do 
    #     expect(Application.first.stage).to eq(stage)
    #     expect(Application.last.stage).to eq(stage)
    #   end

    #   it "expects to return the correct number of candidates" do 
    #     expect(assigns(:candidates)).to match_array([candidate, candidate1, candidate2])
    #   end

    #   it "expects to assign stage to the right stage" do 
    #     expect(assigns(:stage)).to eq(stage)
    #   end

    #   it "expects to assign job to the right job" do 
    #     expect(assigns(:job)).to eq(job)
    #   end

    #   it "renders the create template" do
    #     expect(response).to render_template :move_stage
    #   end
    # end
  end

  describe "GET application_form" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :application_form, candidate_id: candidate.id, job: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :application_form, candidate_id: candidate.id, job: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :application_form, candidate_id: candidate.id, job: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :application_form, candidate_id: candidate.id, job: job.id}
    end

    before do 
      xhr :get, :application_form, candidate_id: candidate.id, job: job.id
    end

    it "expects to return the correct number of candidates" do 
      expect(assigns(:candidate)).to eq(candidate)
    end

    it "expects to assign job to the right job" do 
      expect(assigns(:job)).to eq(job)
    end

    it "expects to assign stage to the right questions" do 
      expect(assigns(:questions)).to eq(job.questions)
      expect(assigns(:questions)).to match_array([question, question2])
    end

    it "renders the application_form template" do
      expect(response).to render_template :application_form
    end
  end

  describe "DELETE destroy" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: application.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, id: application.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, id: application.id}
    end

    before do 
      xhr :delete, :destroy, id: application.id
    end

    it "deletes the stage" do 
      expect(Application.count).to eq(2)
    end

    it "renders the update template" do
      expect(response).to render_template :destroy
    end
  end
end