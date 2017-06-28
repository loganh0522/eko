require 'spec_helper'

describe Business::TagsController do 
  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company)}

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new, candidate_id: candidate.id
    end

    it "sets the @candidate to the current instance of the candidate" do 
      expect(assigns(:candidate)).to eq(candidate)
    end
    
    it "set @stage to be a new instance of Tags" do
      expect(assigns(:tag)).to be_new_record 
      expect(assigns(:tag)).to be_instance_of Tag
    end
  end

  describe "POST create" do 
    context "If multiple candidate_ids are included" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:candidate) {Fabricate(:candidate, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, candidate_ids: [candidate.id] tag: {name: "HTML"}
      end

      it "redirects to the new Hiring team path" do   
        expect(response).to redirect_to new_business_job_hiring_team_path(Job.first.id)
      end
      
      it "creates the job posting" do
        expect(Job.count).to eq(1)
      end
    end
  end
end