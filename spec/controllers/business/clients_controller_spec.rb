require 'spec_helper' 

describe Business::ClientsController do 
  let(:company) {Fabricate(:company)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  
  before do  
    set_current_user(alice)
    set_current_company(company)
    job_board
    @client = Fabricate(:client, company: company) 
    @client2 = Fabricate(:client) 
    @contact = Fabricate(:client_contact, client: @client)
  end

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

    it_behaves_like "trial is over" do 
      let(:action) {get :index}
    end

    before do 
      get :index
    end
   
    it "only renders clients that belong to company" do
      expect(company.clients).to eq([@client])
      expect(assigns(:clients)).to eq([@client])
      expect(company.clients.count).to eq(1)
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) {get :show, id: @client.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :show, id: @client.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :show, id: @client.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :show, id: @client.id}
    end

    context "client belongs to the company" do 
      before do 
        xhr :get, :show, id: @client.id
      end

      it "sets client to the instance of client" do 
        expect(assigns(:client)).to eq(@client)
      end

      it "sets client to the instance of client" do 
        expect(assigns(:contacts).first).to eq(@contact)
      end
    end
  end

  describe "GET new" do 
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
      xhr :get, :new
    end

    it "sets @client to be a new instance of client" do 
      expect(assigns(:client)).to be_new_record 
      expect(assigns(:client)).to be_instance_of Client
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
 
    context "Create a client with VALID inputs to the company" do 
      before do  
        xhr :post, :create, client: Fabricate.attributes_for(:client, company: company)
      end

      it "creates the client" do
        expect(Client.count).to eq(3)
      end 

      it "only renders clients that belong to company" do
        expect(company.clients.count).to eq(2)
        expect(assigns(:clients)).to eq([@client, Client.last])
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "Does not create a client with INVALID input" do 
      before do  
        xhr :post, :create, client: Fabricate.attributes_for(:client, company_name: nil)
      end

      it "creates the client" do
        expect(Client.count).to eq(2)
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
      xhr :get, :edit, id: @client.id
    end

    it "sets @client to the client" do 
      expect(assigns(:client)).to eq(@client)
    end

    it "renders the edit template" do 
      expect(response).to render_template :edit
    end
  end

  describe "PATCH update" do 
    context "with valid inputs" do   
      before do 
        xhr :put, :update, id: @client.id, client: {company_name: "Thomas"}
      end

      it "updates the client" do 
        expect(Client.first.company_name).to eq("Thomas")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        xhr :put, :update, id: @client.id, client: {company_name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(Client.first.company_name).to eq(@client.company_name)
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
      xhr :delete, :destroy, id: @client.id
    end

    it "destroys the correct instance of the client" do 
      expect(Client.count).to eq(1)
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end
end