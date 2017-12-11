require 'spec_helper'

describe JobSeeker::UserCertificationsController do 
  describe 'GET index' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:certification){Fabricate(:user_certification, user_id: alice.id)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end
    
    before do 
      set_current_user(alice)
      @entrepreneur = Fabricate(:user_certification, user_id: alice.id)
      @sales = Fabricate(:user_certification, user_id: alice.id)
      xhr :get, :index
    end

    it "set @certifications to the objects that belong to user" do
      expect(alice.user_certifications.count).to eq(2)
      expect(assigns(:certifications)).to match_array([@entrepreneur, @sales])
    end

    it "associates the work experience with the current_user" do
      expect(UserCertification.first.user).to eq(alice)
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET new" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:certification){Fabricate(:user_certification, user_id: alice.id)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    before do 
      set_current_user(alice)
      xhr :get, :new
    end

    it "set @experience to be a new instance of WorkExperience" do
      expect(assigns(:certification)).to be_new_record 
      expect(assigns(:certification)).to be_instance_of UserCertification
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:certification){Fabricate.attributes_for(:user_certification, user_id: alice.id)}
    
    before do 
      set_current_user(alice)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, user_certification: certification}
    end

    context "with valid inputs" do 
      before do 
        xhr :post, :create, user_certification: certification
      end

      it "should save the certification" do 
        expect(UserCertification.count).to eq(1)
      end

      it "associates the certification with the current_user" do
        expect(UserCertification.first.user).to eq(alice)
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do    
      before do 
        set_current_user(alice)
        xhr :post, :create, user_certification: {name: nil}
      end

      it "renders the index page" do 
        expect(response).to render_template :create
      end

      it "should save the certification" do 
        expect(UserCertification.count).to eq(0)
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "GET edit" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:certification){Fabricate(:user_certification, user_id: alice.id)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: certification.id}
    end
    
    before do 
      set_current_user(alice)
      certification
      xhr :get, :edit, id: certification.id
    end

    it "sets @certification to the correct certification" do 
      expect(assigns(:certification)).to eq(certification)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:certification){Fabricate(:user_certification, user_id: alice.id)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: certification.id, user_certification: {name: "Screened"}}
    end

    context "with valid inputs" do 
      before do 
        set_current_user(alice)
        certification 
        xhr :put, :update, id: certification.id, user_certification: {name: "Screened"}
      end

      it "save the updates made on the object" do 
        expect(UserCertification.last.name).to eq("Screened")
      end

      it "renders to the proper update action" do 
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      let(:certification){Fabricate(:user_certification, user_id: alice.id, name: "title")}
      
      before do 
        set_current_user(alice)
        certification 
        xhr :put, :update, id: certification.id, user_certification: {name: nil}
      end

      it "does not update the user_certification" do 
        expect(UserCertification.last.name).to eq("title")
      end
      
      it "renders to the update action page" do 
        expect(response).to render_template :update
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "DELETE destroy" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:certification){Fabricate(:user_certification, user_id: alice.id)}
    let(:certification1){Fabricate(:user_certification, user_id: alice.id)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: certification.id}
    end
    
    before do 
      set_current_user(alice)
      certification
      certification1 
      xhr :delete, :destroy, id: certification.id   
    end

    it "deletes the experience" do 
      expect(UserCertification.count).to eq(1)
    end

    it "deletes the proper certification" do 
      expect(UserCertification.first).to eq(certification1)
    end
  end
end