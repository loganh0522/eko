require 'spec_helper'

describe Business::DefaultStagesController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      get :index
    end 

    context "user is an admin" do 
      it "expects to return the correct number of stages" do 
        expect(company.default_stages.count).to eq(6)
      end

      it "expects to return the correct stage first" do 
        expect(company.default_stages.first.name).to eq("Screen")
      end
    end
  end 


  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new
    end
    
    it "set @email_template to be a new instance of Tags" do
      expect(assigns(:stage)).to be_new_record 
      expect(assigns(:stage)).to be_instance_of DefaultStage
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:stage) {Fabricate.attributes_for(:default_stage, company: company, position: 1)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create}
    end

    context "with valid inputs" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, default_stage: stage
      end

      it "creates the default stage" do
        expect(DefaultStage.count).to eq(7)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the default stage for current company" do 
        expect(company.default_stages.count).to eq(7)
      end
    end

    context "create with invalid inputs" do     
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, default_stage: {name: nil}
      end

      it "creates the default stages" do
        expect(DefaultStage.count).to eq(6)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the default stages for current company" do 
        expect(company.default_stages.count).to eq(6)
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:stage) {Fabricate(:default_stage, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: stage.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: stage.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: stage.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: stage.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :edit, id: stage.id
    end
    
    it "sets the @default_stage to the correct stage" do 
      expect(assigns(:stage)).to eq(stage)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: 1, default_stage: {name: "Thomas Johnson"}}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: 1, default_stage: {name: "Thomas Johnson"}}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: 1, default_stage: {name: "Thomas Johnson"}}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: 1, default_stage: {name: "Thomas Johnson"}}
    end

    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:stage) {Fabricate(:default_stage, company: company)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        stage
        xhr :put, :update, id: stage.id, default_stage: {name: "Thomas Johnson"}
      end

      it "updates the name of stage" do 
        expect(DefaultStage.last.name).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:stage) {Fabricate(:default_stage, company: company)}
      
      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: stage.id, default_stage: {name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(DefaultStage.last.name).to eq("Screen")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:stage) {Fabricate(:default_stage, company: company)}
    let(:stage2) {Fabricate(:default_stage, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      stage
      stage2
      xhr :delete, :destroy, id: stage.id 
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: stage.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, id: stage.id}
    end
    
    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, id: stage.id}
    end

    it "deletes the stage" do 
      expect(company.default_stages.count).to eq(7)
    end

    it "expects the response to render destroy template" do
      expect(response).to render_template :destroy
    end
  end
end