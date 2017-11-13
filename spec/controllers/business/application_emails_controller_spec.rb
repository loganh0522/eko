require 'spec_helper'

describe Business::ApplicationEmailsController do 
  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:email) {Fabricate(:application_email, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: email.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action)  {xhr :get, :edit, id: email.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action)  {xhr :get, :edit, id: email.id}
    end

    it_behaves_like "trial is over" do 
      let(:action)  {xhr :get, :edit, id: email.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :edit, id: email.id
    end
    
    it "sets the @default_stage to the correct stage" do 
      expect(assigns(:email)).to eq(email)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:email) {Fabricate(:application_email, company: company, body: "Screen")} 
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: 1, application_email: {body: "Thomas Johnson"}}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: 1, application_email: {body: "Thomas Johnson"}}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: 1, application_email: {body: "Thomas Johnson"}}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: 1, application_email: {body: "Thomas Johnson"}}
    end

    context "with valid inputs" do
      before do 
        set_current_company(company)
        set_current_user(alice)
        email
        xhr :put, :update, id: email.id, application_email: {body: "Thomas Johnson"}
      end

      it "updates the name of stage" do 
        expect(ApplicationEmail.last.body).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        set_current_company(company)
        set_current_user(alice)
        email
        xhr :put, :update, id: email.id, application_email: {body: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(ApplicationEmail.last.body).to eq("Screen")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end
end