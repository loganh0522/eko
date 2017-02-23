require 'spec_helper'

describe Business::ActivitiesController do 
  describe "GET index" do     
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index}
    end

    it "sets the @activities to the activities that belong to the current company" do 
      company = Fabricate(:company)
      alice = Fabricate(:user, company: company)
      set_current_user(alice)
      set_current_company(company)
      activity1 = Fabricate(:activity, company: company) 
      activity2 = Fabricate(:activity) 
      get :index
      expect(assigns(:jobs)).to eq([sales_rep1])
    end
  end
end