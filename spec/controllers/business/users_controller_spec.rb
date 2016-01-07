require 'spec_helper' 

describe Business::UsersController do 
  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    let(:company) {Fabricate(:company)}
    let(:subsidiary) {Fabricate(:subsidiary, company: company)}
    let(:alice) {Fabricate(:user, company: company)}

    before do 
      set_current_company(company)
      set_current_user(alice)
      get :index
    end

    it "sets the @users to the users that belong to current company" do 
      expect(assigns(:users)).to eq([alice])
    end

    it "sets the invitation to a new instance" do
      expect(assigns(:invitation)).to be_instance_of(Invitation)
      expect(assigns(:invitation)).to be_new_record 
    end
  end
end