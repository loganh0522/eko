require 'spec_helper'

describe Business::StagesController do 
  describe "GET new" do 
    context "when user belongs to a company" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company)}
      let(:job) {Fabricate(:job, company: company, user_ids: [alice.id])}

      before do  
        set_current_user(alice)
        set_current_company(company)
        get :new, job_id: job.id
      end
      
      it "set @stage to be a new instance of Stages" do
        expect(assigns(:stage)).to be_new_record 
        expect(assigns(:stage)).to be_instance_of Stage
      end


    end
  end
end