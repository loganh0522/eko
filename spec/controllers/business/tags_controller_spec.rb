require 'spec_helper'

describe Business::TagsController do 
  let(:company) {Fabricate(:company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:tag) {Fabricate(:tag, company: company)}
  let(:tag1) {Fabricate(:tag, company: company)}
  let(:candidate) {Fabricate(:candidate, company: company)}
  
  before do 
    set_current_user(alice)
    set_current_company(company)
    tag 
    tag1
    tagging = Fabricate(:tagging, candidate: candidate, tag: tag)
    tagging2 = Fabricate(:tagging, candidate: candidate, tag: tag1)
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

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new
    end

    it "set @stage to be a new instance of Tags" do
      expect(assigns(:tag)).to be_new_record 
      expect(assigns(:tag)).to be_instance_of Tag
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

    context "no candidate id present" do 
      before do 
        xhr :post, :create, tag: {name: "HTML", company_id: company.id}  
      end
      
      it "renders the create action" do 
        expect(response).to render_template :create
      end
      
      it "creates the tag" do
        expect(Company.first.tags.count).to eq(3)
        expect(Candidate.first.tags.count).to eq(2)
      end
    end

    context "if multiple candidate_ids are included" do
      before do 
        xhr :post, :create, applicant_ids: "#{candidate.id}", tag: {name: "HTML", company_id: company.id}  
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
      
      it "creates the tag" do
        expect(Company.first.tags.count).to eq(3)
      end

      it "creates the tagging" do
        expect(Tagging.count).to eq(3)
      end
    end

    context "if candidate_id is present" do
      before do 
        xhr :post, :create, tag: {candidate_id: candidate.id, name: "HTML", company_id: company.id}
      end
      
      it "renders the proper template" do   
        expect(response).to render_template :create
      end
      
      it "creates the tag" do
        expect(Candidate.first.tags.count).to eq(3)
        expect(Company.first.tags.count).to eq(3)
        expect(Tagging.count).to eq(3)
      end
    end
  end

  describe "destroy DELETE" do 
    context "if candidate_id present" do 
      before do 
        xhr :delete, :destroy, id: tag.id, candidate_id: candidate.id
      end

      it "destroys the tagging not the tag" do
        expect(company.tags.count).to eq(2)
      end

      it "destroys the correct tagging" do
        expect(Tagging.count).to eq(1)
      end

      it "it renders the proper action" do   
        expect(response).to render_template :destroy
      end
    end

    context "if candidate_id NOT present" do 
      before do 
        xhr :delete, :destroy, id: tag.id
      end

      it "destroys the tag" do
        expect(company.tags.count).to eq(1)
      end

      it "destroys the tag" do
        expect(company.tags.first).to eq(tag1)
      end

      it "destroys the correct tagging" do
        expect(Tagging.count).to eq(1)
      end

      it "it renders the proper action" do   
        expect(response).to render_template :destroy
      end
    end
  end
end