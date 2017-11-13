require 'spec_helper'

describe Business::RejectionReasonsController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:tag) {Fabricate(:tag, company: company)}
    let(:tag1) {Fabricate(:tag, company: company)}
    let(:tag2) {Fabricate(:tag, company: company)}
    
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
      tag
      tag1
      get :index
    end 

    it "expects to return the correct number of rejection reasons" do 
      expect(company.rejection_reasons.count).to eq(7)
    end

    it "expects to return the company tags" do 
      expect(company.tags.count).to eq(2)
    end

    it "sets the @tags to the tags that belong to the current company" do    
      expect(assigns(:tags)).to eq([tag, tag1])
    end



    it "sets the @email to the application_email that belongs to the current company" do    
      expect(assigns(:email)).to eq(company.application_email)
    end

    it "expects to return the correct number of job postings" do 
      expect(company.rejection_reasons.first.body).to eq("Under/Overqualified")
    end
  end 

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}

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
      xhr :get, :new
    end
    
    it "set @rejection_reason to be a new instance of RejectionReason" do
      expect(assigns(:rejection_reason)).to be_new_record 
      expect(assigns(:rejection_reason)).to be_instance_of RejectionReason
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:reason) {Fabricate.attributes_for(:rejection_reason, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create}
    end

    context "with valid inputs" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, rejection_reason: reason
      end

      it "creates the email template" do
        expect(RejectionReason.count).to eq(8)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the email template for current company" do 
        expect(company.rejection_reasons.count).to eq(8)
      end
    end

    context "creates invalid inputs" do     
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, rejection_reason: {body: nil}
      end

      it "creates the rejection reason" do
        expect(RejectionReason.count).to eq(7)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the rejection reason to the current company" do 
        expect(company.rejection_reasons.count).to eq(7)
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:reason) {Fabricate(:rejection_reason, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: reason.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: reason.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: reason.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: reason.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :edit, id: reason.id
    end
    
    it "sets the @email_template to the correct template" do 
      expect(assigns(:rejection_reason)).to eq(reason)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:reason) {Fabricate(:rejection_reason, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: reason.id, rejection_reason: {body: "Thomas Johnson"}}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: reason.id, rejection_reason: {body: "Thomas Johnson"}}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: reason.id, rejection_reason: {body: "Thomas Johnson"}}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: reason.id, rejection_reason: {body: "Thomas Johnson"}}
    end

    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:reason) {Fabricate(:rejection_reason, company: company)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: reason.id, rejection_reason: {body: "Thomas Johnson"}
      end

      it "updates the name of stage" do 
        expect(RejectionReason.last.body).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:reason) {Fabricate(:rejection_reason, company: company)}
      
      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: reason.id, rejection_reason: {name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(RejectionReason.last.body).to eq(reason.body)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:reason) {Fabricate(:rejection_reason, company: company)}
    let(:reason2) {Fabricate(:rejection_reason, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      reason
      reason2
      xhr :delete, :destroy, id: reason.id 
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: reason.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, id: reason.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, id: reason.id}
    end

    it "deletes the reason" do 
      expect(company.rejection_reasons.count).to eq(8)
    end

    it "expects the response to render destroy template" do
      expect(response).to render_template :destroy
    end
  end

end