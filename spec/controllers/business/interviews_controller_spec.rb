require 'spec_helper'

describe Business::InterviewsController do 
  let(:company) {Fabricate(:company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:job) {Fabricate(:job, company: company)}
  let(:candidate) {Fabricate(:candidate, company: company)}
  let(:interview) {Fabricate(:interview, company: company, candidate: candidate)}
  let(:interview2) {Fabricate(:interview, company: company, candidate: candidate, job_id: job.id)}
  
  before do  
    set_current_user(alice)
    set_current_company(company)
    job_board
    job
    candidate
    interview
    interview2
  end

  describe "GET job_interviews" do 
    context "@job in params renders job.comments" do 
      before do  
        xhr :get, :job_interviews, job_id: job.id
      end

      it "sets the @interview to the current Job interviews" do 
        expect(job.interviews.count).to eq(1)
        expect(job.interviews.first.title).to eq(interview2.title)
        expect(assigns[:interviews]).to eq([interview2])
      end
    end
  end

  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :index}
    end

    before do  
      get :index
    end

    it "sets interviews to the interviews for current_company" do 
      expect(company.interviews.count).to eq(2)
    end
  end

  describe "GET new" do 
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
      xhr :get, :new
    end

    it "sets @task to be a new instance of Task" do 
      expect(assigns(:interview)).to be_new_record 
      expect(assigns(:interview)).to be_instance_of Interview
    end

    it "expects the response to render new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do  
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :create}
    end

    context "with VALID inputs" do 
      before do  
        xhr :post, :create, interview: Fabricate.attributes_for(:interview, company: company, candidate: candidate, user_ids: alice.id)
      end
      
      it "creates the task" do
        expect(Interview.count).to eq(3)
      end

      it "associates the task to the correct records" do
        expect(Interview.last.company).to eq(company)
        expect(company.interviews.count).to eq(3)
        expect(assigns[:interviews].count).to eq(3)
        expect(Interview.last.candidate).to eq(candidate)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "with INVALID inputs" do 
      before do  
        xhr :post, :create, interview: Fabricate.attributes_for(:interview, title: nil, company: company, user_ids: alice.id)
      end
      
      it "creates the task" do
        expect(Interview.count).to eq(2)
      end

      it "associates the task to the correct records" do
        expect(Interview.last.company).to eq(company)
        expect(company.interviews.count).to eq(2)
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end
  end

  describe "GET edit" do     
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: interview.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: interview.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: interview.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: interview.id}
    end
    
    before do  
      xhr :get, :edit, id: interview.id
    end
    
    it "sets @interview to the correct task" do 
      expect(assigns(:interview)).to eq(interview)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: interview.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: interview.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: interview.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: interview.id}
    end

    context "with valid inputs" do
      before do 
        xhr :put, :update, id: interview.id, interview: {title: "Thomas Johnson"}
      end

      it "updates the interview" do 
        expect(Interview.first.title).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        xhr :put, :update, id: interview.id, interview: {title: nil}
      end

      it "sets the @einterview to the current_user" do 
        expect(Interview.first.title).to eq(interview.title)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: interview.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { xhr :delete, :destroy, id: interview.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { xhr :delete, :destroy, id: interview.id}
    end

    before do  
      xhr :delete, :destroy, id: interview.id
    end

    it "destroys the correct instance of the candidate" do 
      expect(Interview.count).to eq(1)
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end
end