require "spec_helper"
describe Business::CompaniesController do 
  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: company.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: company.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: company.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :edit, id: company.id
    end
    
    it "sets the @room to the correct room" do 
      expect(assigns(:company)).to eq(company)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: company.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: company.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: company.id}
    end

    context "with valid inputs" do
      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: company.id, company: {name: "Thomas Johnson"}
      end

      it "updates the name of stage" do 
        expect(Company.first.name).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do   
      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: company.id, company: {name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(Company.first.name).to eq(company.name)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end
end