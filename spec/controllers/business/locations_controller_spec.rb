require 'spec_helper' 

describe Business::LocationsController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
        let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it "sets the @locations instance varliable" do
      get :new 
      expect(assigns(:location)).to be_new_record 
      expect(assigns(:location)).to be_instance_of Location 
    end 
  end

  describe "POST create"


  describe "GET delete"
end