require 'spec_helper' 

describe Business::ClientContactsController do 
  let(:company) {Fabricate(:company)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:client){ Fabricate(:client, company: company)}
  
  before do  
    set_current_user(alice)
    set_current_company(company)
    job_board
    client
    @client_contact = Fabricate(:client_contact, client_id: client.id) 
    @client_contact2 = Fabricate(:client_contact) 
  end

  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index, client_id: client.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index, client_id: client.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index, client_id: client.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index, client_id: client.id}
    end

    before do 
      get :index, client_id: client.id
    end
   
    it "only renders client_contacts that belong to company" do
      expect(client.client_contacts).to eq([@client_contact])
      expect(assigns(:contacts)).to eq([@client_contact])
      expect(client.client_contacts.count).to eq(1)
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) {get :show, id: @client_contact.id, client_id: client.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :show, id: @client_contact.id, client_id: client.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :show, id: @client_contact.id, client_id: client.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :show, id: @client_contact.id, client_id: client.id}
    end

    context "client_contact belongs to the company" do 
      before do 
        xhr :get, :show, id: @client_contact.id, client_id: client.id
      end

      it "sets client_contact to the instance of client_contact" do 
        expect(assigns(:contact)).to eq(@client_contact)
      end
    end
  end

  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, client_id: client.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, client_id: client.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new, client_id: client.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, client_id: client.id}
    end

    before do  
      xhr :get, :new, client_id: client.id
    end

    it "sets @client_contact to be a new instance of client_contact" do 
      expect(assigns(:contact)).to be_new_record 
      expect(assigns(:contact)).to be_instance_of ClientContact 
    end

    it "expects the response to render new template" do
      expect(response).to render_template :new
    end
  end 

  describe "POST create" do 
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
 
    context "Create a client_contact with VALID inputs to the company" do 
      before do  
        xhr :post, :create, client_id: client.id, client_contact: Fabricate.attributes_for(:client_contact)
      end

      it "creates the client_contact" do
        expect(ClientContact.count).to eq(3)
      end 

      it "only renders client_contacts that belong to company" do
        expect(client.client_contacts.count).to eq(1)
        expect(assigns(:client_contacts)).to eq([ClientContact.last])
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "Does not create a client_contact with INVALID input" do 
      before do  
        xhr :post, :create, client_id: client.id, client_contact: Fabricate.attributes_for(:client_contact, first_name: nil)
      end

      it "creates the client_contact" do
        expect(ClientContact.count).to eq(2)
      end 

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end
  end

  describe "GET edit" do   
    before do  
      xhr :get, :edit, id: @client_contact.id
    end

    it "sets @client_contact to the client_contact" do 
      expect(assigns(:contact)).to eq(@client_contact)
    end

    it "renders the edit template" do 
      expect(response).to render_template :edit
    end
  end

  describe "PATCH update" do 
    context "with valid inputs" do   
      before do 
        xhr :put, :update, id: @client_contact.id, client_contact: {first_name: "Thomas"}
      end

      it "updates the client_contact" do 
        expect(ClientContact.first.first_name).to eq("Thomas")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        xhr :put, :update, id: @client_contact.id, client_contact: {first_name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(ClientContact.first.first_name).to eq(@client_contact.first_name)
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    before do  
      xhr :delete, :destroy, id: @client_contact.id
    end

    it "destroys the correct instance of the client_contact" do 
      expect(ClientContact.count).to eq(1)
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end
end