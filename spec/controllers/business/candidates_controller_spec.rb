require 'spec_helper' 

describe Business::CandidatesController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}

    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
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
      @candidate = Fabricate(:candidate, company: company) 
      @candidate_2 = Fabricate(:candidate) 
      @tag = Fabricate(:tag, company: company)
      get :index
    end

    it "sets the @candidates to the candidates that belong to the current company" do 
      expect(assigns(:candidates)).to eq(company.candidates)
    end

    it "only renders candidates that belong to company" do
      expect(company.candidates.first).to eq(@candidate)
    end

    it "only renders candidates that belong to company" do
      expect(company.candidates.count).to eq(1)
    end

    it "sets @tags to the current_company tags" do 
      expect(company.tags.first).to eq(@tag)
    end

    it "sets @tags to the correct number of tags" do
      expect(company.tags.count).to eq(1)
    end
  end

  describe "GET show" do
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company, manually_created: true)}
 
    before do 
      set_current_user(alice)
      set_current_company(company) 
      job_board
      xhr :get, :show, id: candidate.id
    end

    it "sets candidate to the instance of candidate" do 
      expect(assigns(:candidate)).to eq(candidate)
    end

    it "expects the response to render show template" do
      expect(response).to render_template :show
    end
  end

  describe "GET new" do 
    context "Job not present" do 
      let(:company) {Fabricate(:company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        xhr :get, :new
      end

      it "sets @candidate to be a new instance of Candidate" do 
        expect(assigns(:candidate)).to be_new_record 
        expect(assigns(:candidate)).to be_instance_of Candidate
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "Job present" do 
      let(:company) {Fabricate(:company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        xhr :get, :new, job: job
      end

      it "sets @job to the current instance of Job" do 
        expect(assigns(:job)).to eq(job)
      end

      it "sets @candidate to be a new instance of Candidate" do 
        expect(assigns(:candidate)).to be_new_record 
        expect(assigns(:candidate)).to be_instance_of Candidate
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end
  end 

  describe "POST create" do  
    context "Create a candidate to add to the company" do 
      let(:company) {Fabricate(:company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:candidate) {Fabricate.attributes_for(:candidate, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        xhr :post, :create, candidate: candidate
      end

      it "creates the candidate" do
        expect(Candidate.count).to eq(1)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "Create a candidate and an application for job" do 
      let(:company) {Fabricate(:company)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      let(:candidate) {Fabricate.attributes_for(:candidate, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        xhr :post, :create, job_id: job.id, candidate: candidate
      end

      it "creates the candidate" do
        expect(Candidate.count).to eq(1)
      end

      it "creates an application" do
        expect(Application.count).to eq(1)
      end

      it "associations the candidate with the job" do
        expect(Candidate.first.jobs.first).to eq(job)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}    
    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      xhr :get, :edit, id: candidate.id
    end

    it "sets @candidate to the candidate" do 
      expect(assigns(:candidate)).to eq(candidate)
    end

    it "renders the edit template" do 
      expect(response).to render_template :edit
    end
  end

  describe "PATCH update" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company)}
    
    context "with valid inputs" do   
      before do 
        set_current_user(alice)
        set_current_company(company)
        job_board
        xhr :put, :update, id: candidate.id, candidate: {first_name: "Thomas", last_name: "houston", email: "Thomashouston@email.com"}
      end

      it "updates the candidate" do 
        expect(Candidate.first.first_name).to eq("Thomas")
        expect(Candidate.first.last_name).to eq("houston")
        expect(Candidate.first.email).to eq("Thomashouston@email.com")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      let(:candidate) {Fabricate(:candidate, company: company)}
    
      before do 
        set_current_user(alice)
        set_current_company(company)
        job_board
        xhr :put, :update, id: candidate.id, candidate: {first_name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(Candidate.first.first_name).to eq(candidate.first_name)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company)}
      
    before do  
      set_current_user(alice)
      set_current_company(company)
      candidate_1 = Fabricate(:candidate, company: company)
      candidate_2 = Fabricate(:candidate, company: company)
      xhr :delete, :destroy, id: candidate_1.id
    end

    it "destroys the correct instance of the candidate" do 
      expect(Candidate.count).to eq(1)
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end

  describe "DELETE_MULTIPLE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company)}
    
    before do  
      set_current_user(alice)
      set_current_company(company)
      candidate = Fabricate(:candidate, company: company)
      candidate_2 = Fabricate(:candidate, company: company)
      candidate_3 = Fabricate(:candidate, company: company)
      candidate_4 = Fabricate(:candidate, company: company)
      xhr :delete, :destroy_multiple, applicant_ids: "#{candidate.id}, #{candidate_2.id}"
    end

    it "destroys the correct instance of the candidate" do 
      expect(Candidate.count).to eq(2)
    end

    it "renders the destroy_multiple template" do 
      expect(response).to render_template :destroy_multiple
    end
  end
end