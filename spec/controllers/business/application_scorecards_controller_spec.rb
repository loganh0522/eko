require 'spec_helper'

describe Business::ApplicationScorecardsController do 
  describe "GET index" do 
    context "when user belongs to current_company" do
      it_behaves_like "requires sign in" do
        let(:action) {get :index}
      end

      it_behaves_like "user does not belong to company" do 
        let(:action) {get :index}
      end

      it_behaves_like "company has been deactivated" do
        let(:action) {get :index}
      end
    end
  end
end