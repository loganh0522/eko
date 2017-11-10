require 'spec_helper'

describe Business::TagsController do 
  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :index}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:tag) {Fabricate(:tag, company: company)}
    let(:tag1) {Fabricate(:tag, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      tag 
      tag1
      get :index
    end

    it "sets the @tags to the tags that belong to the current company" do    
      expect(assigns(:tags)).to eq([tag, tag1])
    end

    it "expects to return the correct number of job postings" do 
      expect(company.tags.count).to eq(2)
    end
  end

  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:tag) {Fabricate(:tag, company: company)}
    let(:tag1) {Fabricate(:tag, company: company)}

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new
    end

    it "set @stage to be a new instance of Tags" do
      expect(assigns(:tag)).to be_new_record 
      expect(assigns(:tag)).to be_instance_of Tag
    end
    
    context 'if candidate_id present? ' do  
      it "sets the @candidate to the current instance of the candidate" do 
        xhr :get, :new, candidate_id: candidate.id
        expect(assigns(:candidate)).to eq(candidate)
      end
    end  
  end

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, company: company}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, company: company}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, company: company}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:tag) {Fabricate(:tag, company: company)}
    let(:tag1) {Fabricate(:tag, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}
    
    before do  
      set_current_user(alice)
      set_current_company(company)
    end

    context "no candidate id present" do 
      it "renders the create action" do 
        xhr :post, :create, candidate_ids: [candidate.id], tag: {name: "HTML"}  
        expect(response).to render :create
      end
      
      it "creates the tag" do
        xhr :post, :create, tag: {name: "HTML"}
        expect(company.tags.count).to eq(1)
      end
    end

    context "if multiple candidate_ids are included" do
      it "renders the create action" do 
        xhr :post, :create, candidate_ids: [candidate.id], tag: {name: "HTML"}  
        expect(response).to render :create
      end
      
      it "creates the tag" do
        xhr :post, :create, candidate_ids: [candidate.id], tag: {name: "HTML"}
        expect(company.tags.count).to eq(1)
      end
    end

    context "if candidate_id is present" do
      it "redirects to the new Hiring team path" do   
        xhr :post, :create, candidate_id: candidate.id, tag: {name: "HTML"}
        expect(response).to render :create
      end
      
      it "creates the tag" do
        xhr :post, :create, candidate_id: candidate.id, tag: {name: "HTML"}
        expect(company.tags.count).to eq(1)
      end
    end
  end
end