require 'spec_helper'

describe Business::RoomsController do 
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

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new
    end
    
    it "set @room to be a new instance of Room" do
      expect(assigns(:room)).to be_new_record 
      expect(assigns(:room)).to be_instance_of Room
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:room) {Fabricate.attributes_for(:room, company: company)}

    context "with valid inputs" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, room: room
      end

      it "creates the room" do
        expect(Room.count).to eq(1)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the room for current company" do 
        expect(company.rooms.count).to eq(1)
      end
    end

    context "creates invalid inputs" do     
      before do  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, room: {name: nil}
      end

      it "creates the email template" do
        expect(Room.count).to eq(0)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "associates the room to current company" do 
        expect(company.rooms.count).to eq(0)
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:room) {Fabricate(:room, company: company)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: room.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: room.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: room.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :edit, id: room.id
    end
    
    it "sets the @room to the correct room" do 
      expect(assigns(:room)).to eq(room)
    end

    it "expects the response to render edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:room) {Fabricate(:room, company: company)}

      before do 
        set_current_company(company)
        set_current_user(alice)
        room
        xhr :put, :update, id: room.id, room: {name: "Thomas Johnson"}
      end

      it "updates the name of stage" do 
        expect(Room.first.name).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:room) {Fabricate(:room, company: company)}
      
      before do 
        set_current_company(company)
        set_current_user(alice)
        xhr :put, :update, id: room.id, room: {name: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(Room.last.name).to eq("Room")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:room) {Fabricate(:room, company: company)}
    let(:room2) {Fabricate(:room, company: company)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      room
      room2
      xhr :delete, :destroy, id: room.id 
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: room.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, id: room.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :delete, :destroy, id: room.id}
    end

    it "deletes the stage" do 
      expect(company.rooms.count).to eq(1)
    end

    it "expects the response to render destroy template" do
      expect(response).to render_template :destroy
    end
  end
end