require 'spec_helper' 

describe Business::LocationsController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new}
    end

    it "sets the @locations instance varliable" do
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      get :new 
      expect(assigns(:location)).to be_new_record 
      expect(assigns(:location)).to be_instance_of Location 
    end 
  end

  describe "POST create" do 
    it_behaves_like "requires sign in" do
        let(:action) {post :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create}
    end

    context "with valid inputs" do 
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        post :create, location: Fabricate.attributes_for(:location), company: company, subsidiary_id: nil
      end

      it "redirects to the business/locations page" do 
        expect(response).to redirect_to business_locations_path
      end

      it "saves the location" do 
        expect(Location.count).to eq(1)
      end

      it "associates the location with the company" do 
        expect(Location.first.company).to eq(company)
      end
    end
      
    context "with new_for_subsidiary" do
      let(:company) {Fabricate(:company)}
      let(:subsidiary) {Fabricate(:subsidiary, company: company)}
      let(:alice) {Fabricate(:user, company: company)}
      
      before do  
        set_current_user(alice)
        set_current_company(company)
        post :create, location: Fabricate.attributes_for(:location), company: company, subsidiary: subsidiary
      end

      it "saves the location" do 
        expect(Location.count).to eq(1)
      end

      it "belongs to a the proper subsidiary" do 
        expect(Location.first.subsidiary).to eq(subsidiary)
      end

      it "redirects to the business/locations page" do 
        expect(response).to redirect_to business_locations_path
      end
    end
  end

  describe "GET new_for_subsidiary" do 
    it_behaves_like "requires sign in" do
        let(:action) {get :new_for_subsidiary, subsidiary_id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new_for_subsidiary, subsidiary_id: 4}
    end

    context "with valid subsidiary"
      let(:company) {Fabricate(:company)}
      let(:subsidiary) {Fabricate(:subsidiary, company: company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        get :new_for_subsidiary, subsidiary_id: subsidiary.id
      end

      it "renders the new view template" do 
        expect(response).to render_template :new
      end

      it "sets the @subsidiary" do 
        expect(assigns(:subsidiary)).to eq(subsidiary.id)
      end

      it "sets @location to be a new instance" do 
        expect(assigns(:location)).to be_new_record
        expect(assigns(:location)).to be_instance_of Location
      end

    context "with invalid subsidiary" do   
      it "redirects the user to the business_subsidiary_path" do 
        get :new_for_subsidiary, subsidiary_id: 1
        expect(response).to redirect_to business_root_path
      end
    end
  end
end