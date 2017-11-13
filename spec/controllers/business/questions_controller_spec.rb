require 'spec_helper' 

describe Business::QuestionsController do 
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
      let(:action) {get :index }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index}
    end

    it_behaves_like "trial is over" do 
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
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new, job_id: job.id
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end
    
    it "set @question to be a new instance of Questions" do
      expect(assigns(:questions)).to be_new_record 
      expect(assigns(:questions)).to be_instance_of Questions
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:question) {Fabricate.attributes_for(:question, job_id: job.id)}
   
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)
      xhr :post, :create, question: question, job_id: job.id
    end

    it "creates the questionairre" do 
      expect(Question.count).to eq(1)
    end

    it "associates the scorecard with the job" do 
      expect(Question.first.job).to eq(job)
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:question) {Fabricate(:question, job_id: job.id)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end
    
    before do      
      set_current_user(alice)
      set_current_company(company)   
      xhr :get, :edit, id: question.id, job_id: job.id  
    end

    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @questionairre to the correct job posting" do 
      expect(assigns(:question)).to eq(question)
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate(:stage, job: job)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, name: "Screened"}, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, name: "Screened"}, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, name: "Screened"}, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, name: "Screened"}, job_id: job.id}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)    
      job_board  
      xhr :put, :update, id: question.id, question: {job_id: job.id, name: "Screened"}, job_id: job.id
    end

    it "save the updates made on the object" do 
      expect(Question.last.name).to eq("Screened")
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate(:stage, job: job, name: "deleted")}
    
    before do 
      set_current_user(alice)
      set_current_company(company)  
      job_board
      stage
      xhr :delete, :destroy, job_id: job.id, id: stage.id   
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: stage.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: stage.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: stage.id}
    end

    it "deletes the stage" do 
      expect(Stage.count).to eq(6)
    end

    it "deletes the stage" do 
      expect(job.stages.last.name).to eq("Hired")
    end
  end
end