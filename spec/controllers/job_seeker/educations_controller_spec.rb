require 'spec_helper'

describe JobSeeker::EducationsController do 
  describe "GET new" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    before do 
      set_current_user(alice)
      xhr :get, :new
    end

    it "set @education to be a new instance of Workeducation" do
      expect(assigns(:education)).to be_new_record 
      expect(assigns(:education)).to be_instance_of Education
    end

    it "sets @user to be current_user" do
      expect(assigns(:user)).to eq(alice)
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:education) {Fabricate.attributes_for(:education, user: alice)}
    
    before do 
      set_current_user(alice)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, education: education}
    end

    context "with valid inputs" do 
      before do 
        xhr :post, :create, education: education
      end

      it "should save the work education" do 
        expect(Education.count).to eq(1)
      end

      it "associates the work education with the current_user" do
        expect(Education.first.user).to eq(alice)
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      
      before do 
        set_current_user(alice)
        xhr :post, :create, user_id: alice.id, education: {school: 'title'} 
      end

      it "redirects to the profile index page" do 
        expect(response).to render_template :create
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "GET edit" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:education){Fabricate(:education, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: education.id}
    end
    
    before do 
      set_current_user(alice)
      education
      xhr :get, :edit, id: education.id
    end

    it "sets @education to the correct education" do 
      expect(assigns(:education)).to eq(education)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:education){Fabricate(:education, user: alice)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, user_id: alice.id, id: education.id}
    end

    before do 
      set_current_user(alice)
      education   
      xhr :put, :update, id: education.id, education: {school: "Screened"}
    end

    it "save the updates made on the object" do 
      expect(Education.last.school).to eq("Screened")
    end
  end

  describe "DELETE destroy" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:education) {Fabricate(:education, user: alice)}
    let(:education2) {Fabricate(:education, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: education.id}
    end
    
    before do 
      set_current_user(alice)
      education
      education2
      xhr :delete, :destroy, id: education.id   
    end

    it "deletes the education" do 
      expect(Education.count).to eq(1)
    end
  end
end