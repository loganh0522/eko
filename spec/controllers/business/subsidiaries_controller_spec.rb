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

    it "renders the :new template"

  end
end

