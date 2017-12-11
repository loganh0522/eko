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
      @candidate2 = Fabricate(:candidate) 
      @tag = Fabricate(:tag, company: company)
      @tag1 = Fabricate(:tag)
      get :index
    end

    it "only renders candidates that belong to company" do
      expect(company.candidates).to eq([@candidate])
      expect(assigns(:candidates)).to eq([@candidate])
      expect(company.candidates.count).to eq(1)
    end

    it "sets @tags to the current_company tags" do 
      expect(company.tags.first).to eq(@tag)
      expect(company.tags).to eq([@tag])
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

    context "candidate belongs to the company" do 
      it "sets candidate to the instance of candidate" do 
        expect(assigns(:candidate)).to eq(candidate)
      end

      it "expects the response to render show template" do
        expect(response).to render_template :show
      end
    end
  end

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    
    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
    end

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

    context "Job not present" do 
      before do  
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
      before do  
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
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate.attributes_for(:candidate, company: company)}
    
    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      @candidate = Fabricate(:candidate, company: company) 
      @candidate2 = Fabricate(:candidate) 
    end

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
 
    context "Create a candidate with VALID inputs to the company" do 
      before do  
        xhr :post, :create, candidate: candidate
      end

      it "creates the candidate" do
        expect(Candidate.count).to eq(3)
      end 

      it "only renders candidates that belong to company" do
        expect(company.candidates.count).to eq(2)
        expect(assigns(:candidates)).to eq([Candidate.last, @candidate])
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "Does not create a candidate with INVALID input" do 
      before do  
        xhr :post, :create, candidate: Fabricate.attributes_for(:candidate, first_name: nil)
      end

      it "creates the candidate" do
        expect(Candidate.count).to eq(2)
      end 

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "Create a candidate with VALID work_experience, education, social link" do 
      before do 
        xhr :post, :create, tags: "Rails,Sales", job_id: "", candidate: {first_name: "Dave", last_name: "Goldfarb", email: "dgoldfarb@example.com", phone: "", social_links_attributes: {"0"=>{url:"linkedin", kind:"LinkedIn"}}, work_experiences_attributes: {"0"=>{title:"Sales", company_name:"Drugs",start_month:"", start_year:"", end_month: "", end_year:"", current_position: "0", description: ""}}, educations_attributes: {"0"=>{school:"Life", degree:"School", start_month:"January", start_year:"", end_month: "January", end_year: "", description:""}}, company: company, manually_created: "true"}
      end

      it "creates the candidate" do
        expect(Candidate.count).to eq(3)
      end 

      it "creates the tags and associates them to the candidates" do
        expect(Tag.count).to eq(2)
        expect(Tagging.count).to eq(2)
        expect(Candidate.last.tags.count).to eq(2)
      end 

      it "creates the education and associates them to the candidate" do
        expect(Education.count).to eq(1)
        expect(Candidate.last.educations.count).to eq(1)
        expect(Candidate.last.educations.first.school).to eq("Life")
      end 

      it "creates the work_experience and associates them to the candidate" do
        expect(WorkExperience.count).to eq(1)
        expect(Candidate.last.work_experiences.count).to eq(1)
        expect(Candidate.last.work_experiences.first.title).to eq("Sales")
      end 

      it "creates the social_link and associates them to the candidate" do
        expect(SocialLink.count).to eq(1)
        expect(Candidate.last.social_links.count).to eq(1)
        expect(Candidate.last.social_links.first.url).to eq("https://linkedin")
      end 

      it "renders the create action" do 
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
        xhr :post, :create, job_id: job.id, candidate: candidate
      end

      it "creates the candidate" do
        expect(Candidate.count).to eq(3)
      end

      it "creates an application" do
        expect(Application.count).to eq(1)
      end

      it "associations the candidate with the job" do
        expect(Candidate.last.jobs).to eq([job])
      end

      it "only renders candidates that belong to job" do
        expect(job.candidates.count).to eq(1)
        expect(assigns(:candidates)).to eq([Candidate.last])
        expect(assigns(:candidates).count).to eq(1)
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