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
    let(:project) {Fabricate.attributes_for(:project, user: alice)}
    
    before do 
      set_current_user(alice)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, project: project}
    end

    context "with valid inputs" do 
      before do 
        xhr :post, :create, project: project
      end

      it "should save the work experience" do 
        expect(Project.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(Project.first.user).to eq(alice)
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      
      before do 
        set_current_user(alice)
        xhr :post, :create, project: {title: 'title'} 
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
    let(:project){Fabricate(:project, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: project.id}
    end
    
    before do 
      set_current_user(alice)
      experience
      xhr :get, :edit, id: project.id
    end

    it "sets @project to the correct work_experience" do 
      expect(assigns(:project)).to eq(project)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience){Fabricate(:project, user: alice)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: project.id}
    end

    context "with valid inputs" do 
      before do 
        set_current_user(alice)
        experience  
        xhr :put, :update, id: project.id, project: {title: "Screened"}
      end

      it "save the updates made on the object" do 
        expect(Project.last.title).to eq("Screened")
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :update
      end
    end

     context "with INVALID inputs" do 
      before do 
        set_current_user(alice)
        experience  
        xhr :put, :update, id: project.id, project: {title: nil}
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
    let(:project) {Fabricate(:project, user: alice)}
    let(:project2) {Fabricate(:project, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: experience.id}
    end
    
    before do 
      set_current_user(alice)
      project
      project2
      xhr :delete, :destroy, id: project.id   
    end

    it "deletes the experience" do 
      expect(Project.count).to eq(1)
    end
  end
end