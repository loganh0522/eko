require 'spec_helper'

describe Business::EmailTemplatesController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:notcompany) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:etemp) {Fabricate(:email_template, company: company)}
    let(:etemp2) {Fabricate(:email_template, company: company)}
    let(:etemp3) {Fabricate(:email_template, company: notcompany )}
    
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index }
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
      etemp
      etemp2
      etemp3
      get :index
    end 

    context "user is an admin" do 
      it "sets @email_templates to the current_company templates" do 
        expect(assigns(:email_templates)).to eq([etemp, etemp2])
      end

      it "expects to return the correct number of email templates" do 
        expect(company.email_templates.count).to eq(2)
      end

      it "expects to return the correct number of email templates" do 
        expect(EmailTemplate.count).to eq(3)
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
      expect(assigns(:email_template)).to be_new_record 
      expect(assigns(:email_template)).to be_instance_of EmailTemplate
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:etemp) {Fabricate.attributes_for(:email_template, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create}
    end

    context "with valid inputs" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, email_template: etemp
      end

      it "creates the email template" do
        expect(EmailTemplate.count).to eq(1)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the email template for current company" do 
        expect(company.email_templates.count).to eq(1)
      end
    end

    context "creates invalid inputs" do     
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, email_template: {title: ""}
      end

      it "creates the email template" do
        expect(EmailTemplate.count).to eq(0)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the email template for current company" do 
        expect(company.email_templates.count).to eq(0)
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:etemp) {Fabricate(:email_template, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: etemp.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :edit, id: etemp.id
    end
    
    it "sets the @email_template to the correct template" do 
      expect(assigns(:email_template)).to eq(etemp)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:etemp) {Fabricate(:email_template, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: etemp.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:etemp) {Fabricate(:email_template, company: company)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: etemp.id, email_template: {title: "Thomas Johnson"}
      end

      it "sets the @email_signature to the current_user" do 
        expect(EmailTemplate.first.title).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:etemp) {Fabricate(:email_template, company: company)}
      
      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: etemp.id, email_template: {title: ""}
      end

      it "sets the @email_signature to the current_user" do 
        expect(EmailTemplate.first.title).to eq("Rejection E-mail")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:etemp) {Fabricate(:email_template, company: company)}
    let(:etemp2) {Fabricate(:email_template, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      etemp2
      etemp  
      xhr :delete, :destroy, id: etemp.id 
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: etemp.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, id: etemp.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: etemp.id}
    end

    it "deletes the stage" do 
      expect(company.email_templates.count).to eq(1)
    end

    it "expects the response to render destroy template" do
      expect(response).to render_template :destroy
    end
  end
end