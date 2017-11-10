require 'spec_helper'

describe Business::EmailSignaturesController do 
  describe "GET edit" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, user_id: alice.id, id: signature.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, user_id: alice.id, id: signature.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, user_id: alice.id, id: signature.id}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:signature) {Fabricate(:email_signature, user: alice)}

    before do 
      set_current_company(company)
      set_current_user(alice)
      xhr :get, :edit, user_id: alice.id, id: signature.id
    end

    it "sets the @email_signature to the current_user" do 
      expect(assigns(:signature)).to eq(signature)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, user_id: 1, id: 1, email_signature: {signature: "Thomas Johnson"}}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, user_id: 1, id: 1, email_signature: {signature: "Thomas Johnson"}}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, user_id: 1, id: 1, email_signature: {signature: "Thomas Johnson"}}
    end

    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:signature) {Fabricate(:email_signature, user: alice)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, user_id: alice.id, id: signature.id, email_signature: {signature: "Thomas Johnson"}
      end

      it "sets the @email_signature to the current_user" do 
        expect(EmailSignature.first.signature).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:signature) {Fabricate(:email_signature, user: alice)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, user_id: alice.id, id: signature.id, email_signature: {signature: "Logan Houston"}
      end

      it "sets the @email_signature to the current_user" do 
        expect(EmailSignature.first.signature).to eq("Logan Houston")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end
end