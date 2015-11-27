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
      let(:subsidiary) {Fabricate(:subsidiary)}
      let(:alice) {Fabricate(:user, company: company)}

      before do  
        set_current_user(alice)
        set_current_company(company)
        post :create, location: Fabricate.attributes_for(:location), company: company
      end

      it "redirects to the business/subsidiary locations path" do 
        
      end

      it "saves the new location" 
      it "associates the location with the correct business"
    end

    context "with invalid inputs" do 
      it "does not create the location" 
      it "renders the location show page"
    end
  end


  describe "GET delete"
end