require 'spec_helper' 

describe Business::ScorecardsController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:scorecard){Fabricate(:scorecard, job_id: job.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
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

    context "when user belongs to current_company" do
      it "sets the @jobs to the correct job" do    
        expect(assigns(:job)).to eq(job)
      end

      it "expects to return the correct number of job postings" do 
        expect(Job.count).to eq(1)
      end

      it "expects to return the associated quesitons of the job posting" do 
        expect(Scorecard.count).to eq(0)
      end
    end
  end

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:scorecard){Fabricate(:scorecard, job_id: job.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      xhr :get, :new, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end
    
    it "set @scorecard to be a new instance of scorecards" do
      expect(assigns(:scorecard)).to be_new_record 
      expect(assigns(:scorecard)).to be_instance_of Scorecard
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, scorecard: scorecard, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, scorecard: scorecard, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create, scorecard: scorecard, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, scorecard: scorecard, job_id: job.id}
    end

    context "with valid input" do 
      before do 
        xhr :post, :create, job_id: job.id, scorecard: { scorecard_sections_attributes: { "0" =>{body: "Scorecard Section", _destroy: "false", section_options_attributes: {"0" => { body: "Section Option", _destroy: "false"}}}}}
      end

      it "creates the scorecard" do 
        expect(Scorecard.count).to eq(1)
      end

      it "associates the scorecard with the job" do 
        expect(ScorecardSection.count).to eq(1)
        expect(ScorecardSection.first.body).to eq("Scorecard Section")
      end

      it "associates the scorecard with the job" do 
        expect(SectionOption.count).to eq(1)
        expect(SectionOption.first.body).to eq("Section Option")
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do 
      before do 
        xhr :post, :create, job_id: job.id, scorecard: { scorecard_sections_attributes: { "0" =>{body: "Scorecard Section", _destroy: "false", section_options_attributes: {"0" => { body: "", _destroy: "false"}}}}}
      end

      it "creates the scorecard" do 
        expect(Scorecard.count).to eq(0)
      end

      it "associates the scorecard with the job" do 
        expect(ScorecardSection.count).to eq(0)
      end

      it "associates the scorecard with the job" do 
        expect(SectionOption.count).to eq(0)
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end


  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      xhr :get, :edit, id: scorecard.id, job_id: job.id  
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: scorecard.id, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: scorecard.id, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: scorecard.id, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: scorecard.id, job_id: job.id}
    end
    
    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @scorecard to the correct scorecard" do 
      expect(assigns(:scorecard)).to eq(scorecard)
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job.id)}
    let(:scorecard_section) {Fabricate(:scorecard_section, scorecard_id: scorecard.id)}
    let(:section_option) {Fabricate(:section_option, scorecard_section_id: scorecard_section.id)}
    let(:section_option2) {Fabricate(:section_option, scorecard_section_id: scorecard_section.id)}
    before do 
      set_current_user(alice)
      set_current_company(company)    
      job_board  
      job
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: scorecard.id, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: scorecard.id, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: scorecard.id, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: scorecard.id, job_id: job.id}
    end

    context "with VALID inputs it updates the scorecard sections" do 
      before do 
        scorecard
        scorecard_section
        section_option
        section_option2
        xhr :put, :update, job_id: job.id, id: scorecard.id, scorecard: { scorecard_sections_attributes: { "0" => {body: "Scorecard Section Update", _destroy: "false", section_options_attributes: {"0" => { body: "Section Option Update", _destroy: "false", id: section_option.id}, "1" => { body: "Section Option", _destroy: "1", id: section_option2.id}}, id: scorecard_section.id }}}
      end

      it "associates the scorecard with the job" do 
        expect(ScorecardSection.first.body).to eq("Scorecard Section Update")
      end

      it "deletes the section_option2" do 
        expect(SectionOption.count).to eq(1)
      end 

      it "associates the scorecard with the job" do 
        expect(SectionOption.first.body).to eq("Section Option Update")
      end

      it "renders the create template" do
        expect(response).to render_template :update
      end
    end

    context "with INVALID inputs it updates the scorecard sections" do 
      before do 
        scorecard
        scorecard_section
        section_option
        section_option2
        xhr :put, :update, job_id: job.id, id: scorecard.id, scorecard: { scorecard_sections_attributes: { "0" => {body: "", _destroy: "false", section_options_attributes: {"0" => { body: "", _destroy: "false", id: section_option.id}, "1" => { body: "Section Option", _destroy: "1", id: section_option2.id}}, id: scorecard_section.id }}}
      end

      it "associates the scorecard with the job" do 
        expect(ScorecardSection.first.body).to eq(scorecard_section.body)
      end

      it "associates the scorecard with the job" do 
        expect(SectionOption.first.body).to eq(section_option.body)
      end

      it "renders the create template" do
        expect(response).to render_template :update
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:scorecard) {Fabricate(:scorecard, job_id: job.id)}

    before do 
      set_current_user(alice)
      set_current_company(company)    
      job_board  
      job
      scorecard 
      @scorecard2 = Fabricate(:scorecard, job_id: job.id)
      xhr :delete, :destroy, job_id: job.id, id: scorecard.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: scorecard.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: scorecard.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: scorecard.id}
    end

    it "deletes the scorecard" do 
      expect(Scorecard.count).to eq(1)
    end

    it "renders the destroy template" do
      expect(response).to render_template :destroy
    end
  end
end