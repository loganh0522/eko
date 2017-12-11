require 'spec_helper'

describe Business::StagesController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate(:stage, job_id: job.id)}
    let(:stage2) {Fabricate(:stage, job_id: job.id)}
    let(:stage3) {Fabricate(:stage)}
    
    it_behaves_like "requires sign in" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index, job_id: job.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      get :index, job_id: job.id
    end 

    
    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end

    it "expects to return the correct number of stages" do 
      expect(job.stages.count).to eq(6)
    end
  end 

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}

    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      xhr :get, :new, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end
    
    it "set @stage to be a new instance of Stages" do
      expect(assigns(:stage)).to be_new_record 
      expect(assigns(:stage)).to be_instance_of Stage
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate.attributes_for(:stage, job_id: job.id, name: "Test")}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, job_id: job.id, stage: stage}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, job_id: job.id, stage: stage}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create, job_id: job.id, stage: stage}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, job_id: job.id, stage: stage}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
    end

    context "with valid inputs" do
      before do 
        xhr :post, :create, stage: stage, job_id: job.id
      end

      it "renders the new template" do 
        expect(response).to render_template :create
      end

      it "creates the new stage" do 
        expect(Stage.count).to eq(7)
      end

      it "creates the stage with proper name" do 
        expect(Stage.last.name).to eq("Test")
      end

      it "associates the stage with the job" do 
        expect(Stage.last.job).to eq(job)
      end

      it "adds a new stage last in the list" do 
        expect(Stage.last.position).to eq(7)
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate(:stage, job_id: job.id)}

    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      xhr :get, :edit, id: stage.id, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, job_id: job.id, id: stage.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, job_id: job.id, id: stage.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, job_id: job.id, id: stage.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, job_id: job.id, id: stage.id}
    end

    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @stage to the stage associated with the job posting" do 
      expect(assigns(:stage)).to eq(stage)
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate(:stage, job: job)}

    before do 
      set_current_user(alice)
      set_current_company(company)    
      job_board  
      xhr :put, :update, id: stage.id, stage: {job_id: job.id, name: "Screened"}, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, job_id: job.id, id: stage.id, stage: {job_id: job.id, name: "Screened"} }
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, job_id: job.id, id: stage.id, stage: {job_id: job.id, name: "Screened"} }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, job_id: job.id, id: stage.id, stage: {job_id: job.id, name: "Screened"} }
    end


    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, job_id: job.id, id: stage.id, stage: {job_id: job.id, name: "Screened"} }
    end

    it "save the updates made on the object" do 
      expect(Stage.last.name).to eq("Screened")
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:stage) {Fabricate(:stage, job: job, name: "deleted", position: 6)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)  
      job_board
      stage
      xhr :delete, :destroy, job_id: job.id, id: stage.id   
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: stage.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: stage.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: stage.id}
    end

    it "deletes the stage" do 
      expect(Stage.count).to eq(6)
    end

    it "deletes the stage" do 
      expect(job.stages.last.name).to eq("Hired")
    end

    it "adjusts the stages position" do 
      expect(job.stages.last.position).to eq(6)
      expect(job.stages.first.position).to eq(1)
    end
  end

  # describe "POST sort" do
  #   let(:company) {Fabricate(:company)}
  #   let(:alice) {Fabricate(:user, company: company)}
  #   let(:job) {Fabricate(:job, company: company)}
    
  #   before do 
  #     set_current_user(alice)
  #     set_current_company(company) 
  #     stage1 = Fabricate(:stage, position: 1, job_id: job.id) 
  #     stage2 = Fabricate(:stage, position: 2, job_id: job.id)
  #     xhr :post, :sort, job_id: job.id, stage: [stage2.id, stage1.id]     
  #   end

  #   it_behaves_like "requires sign in" do
  #     let(:action) {xhr :post, :sort, job_id: job.id}
  #   end

  #   it_behaves_like "user does not belong to company" do 
  #     let(:action) {xhr :post, :sort, job_id: job.id}
  #   end

  #   it "reorders the items in the queue" do
  #     expect(stage2.reload.position).to eq(1)
  #   end
  # end
end