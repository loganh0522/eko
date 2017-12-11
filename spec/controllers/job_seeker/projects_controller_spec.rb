require 'spec_helper'

describe JobSeeker::ProjectsController do 
  describe 'GET index' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end
    
    before do 
      set_current_user(alice)
      @entrepreneur = Fabricate(:project, user: alice)
      @sales = Fabricate(:project, user: alice)
      xhr :get, :index
    end

    it "set @work_experiences to the objects that belong to user" do
      expect(alice.work_experiences.count).to eq(2)
      expect(assigns(:work_experiences)).to match_array([@entrepreneur, @sales])
    end

    it "associates the work experience with the current_user" do
      expect(Project.first.user).to eq(alice)
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET new" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    before do 
      set_current_user(alice)
      xhr :get, :new
    end

    it "set @experience to be a new instance of WorkExperience" do
      expect(assigns(:work_experience)).to be_new_record 
      expect(assigns(:work_experience)).to be_instance_of WorkExperience
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience) {Fabricate.attributes_for(:work_experience, user: alice)}
    
    before do 
      set_current_user(alice)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, work_experience: experience}
    end

    context "with valid inputs" do 
      before do 
        xhr :post, :create, work_experience: experience
      end

      it "should save the work experience" do 
        expect(WorkExperience.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(WorkExperience.first.user).to eq(alice)
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      
      before do 
        set_current_user(alice)
        xhr :post, :create, work_experience: {title: 'title'} 
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
    let(:experience){Fabricate(:work_experience, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: experience.id}
    end
    
    before do 
      set_current_user(alice)
      experience
      xhr :get, :edit, id: experience.id
    end

    it "sets @experience to the correct work_experience" do 
      expect(assigns(:work_experience)).to eq(experience)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience){Fabricate(:work_experience, user: alice)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: experience.id}
    end

    context "with valid inputs" do 
      before do 
        set_current_user(alice)
        experience  
        xhr :put, :update, id: experience.id, work_experience: {title: "Screened"}
      end

      it "save the updates made on the object" do 
        expect(WorkExperience.last.title).to eq("Screened")
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      let(:experience){Fabricate(:work_experience, user: alice, title: "title")}
      before do 
        set_current_user(alice)
        experience  
        xhr :put, :update, id: experience.id, work_experience: {title: nil}
      end

      it "does not update the work_experience" do 
        expect(WorkExperience.last.title).to eq("title")
      end
      it "redirects to the profile index page" do 
        expect(response).to render_template :update
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "DELETE destroy" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience) {Fabricate(:work_experience, user: alice)}
    let(:experience2) {Fabricate(:work_experience, user: alice)}
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: experience.id}
    end
    
    before do 
      set_current_user(alice)
      experience
      experience2
      xhr :delete, :destroy, id: experience.id   
    end

    it "deletes the experience" do 
      expect(WorkExperience.count).to eq(1)
    end
  end
end