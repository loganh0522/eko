require 'spec_helper' 

describe Business::CandidatesController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
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
        
    before do  
      set_current_user(alice)
      set_current_company(company)
      @candidate_1 = Fabricate(:candidate, company: company) 
      @candidate_2 = Fabricate(:candidate) 
      get :index
    end

    it "sets the @candidates to the candidates that belong to the current company" do 
      expect(assigns(:candidates)).to eq(company.candidates)
    end

    it "only renders candidates that belong to company" do
      expect(company.candidates.first).to eq(@candidate_1)
    end
  end

  describe "GET show" do
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company, manually_created: true)}
 
    before do 
      set_current_user(alice)
      set_current_company(company) 
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
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
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
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
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
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:candidate) {Fabricate(:candidate, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, candidate: Fabricate.attributes_for(:candidate, company: company)
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
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      let(:candidate) {Fabricate.attributes_for(:candidate, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        tag_1 = 
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
end