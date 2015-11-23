require 'spec_helper' 

describe Business::SubsidiariesController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
        let(:action) {get :index}
      end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it "sets the @subsidiary instance variable" do
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      get :new
      expect(assigns(:subsidiary)).to be_instance_of(Subsidiary) 
    end

    it "renders the :new template" do 
      expect(response).to render_template :new
    end

  end
end

