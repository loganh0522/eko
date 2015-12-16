require 'spec_helper' 

describe Business::SubsidiariesController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new}
    end

    it "sets the @subsidiary instance variable" do
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      get :new
      expect(assigns(:subsidiary)).to be_instance_of(Subsidiary) 
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
        post :create, subsidiary: Fabricate.attributes_for(:subsidiary), company: company
      end

      it "redirects to the business/location page" do 
        expect(response).to redirect_to business_locations_path
      end

      it "creates the subsidiary" do 
        expect(Subsidiary.count).to eq(1)
      end

      it "associates the subsidiary to the current_company" do 
        expect(Subsidiary.first.company).to eq(company)
      end

      it "sets the flash message" do 
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}

      before do      
        set_current_user(alice)
        set_current_company(company)
        post :create, subsidiary: {name: nil}
      end

      it "renders the :new template" do 
        expect(response).to render_template :new
      end

      it "does not create the subsidiary" do 
        expect(Subsidiary.count).to eq(0)
      end
    end
  end

  describe "GET show" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :show, id: 4}
    end

    let(:company) {Fabricate(:company)}
    let(:subsidiary) {Fabricate(:subsidiary, company: company)}
    let(:alice) {Fabricate(:user, company: company)}

    before do      
      set_current_user(alice)
      set_current_company(company)
      get :show, id: subsidiary.id
    end

    it "sets the @subsidiary to the active subsidiary" do
      expect(assigns(:subsidiary)).to eq(subsidiary)
    end
  end
end

