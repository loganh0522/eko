require 'spec_helper'

describe JobSeeker::AccomplishmentsController do 
  describe "GET new" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:exp) {Fabricate(:work_experience, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, {work_experience_id: exp.id}}
    end

    before do 
      set_current_user(alice)
      xhr :get, :new, {work_experience_id: exp.id}
      exp
    end

    it "sets @accomplishment to be a new instance of WorkExperience" do
      expect(assigns(:accomplishment)).to be_new_record 
      expect(assigns(:accomplishment)).to be_instance_of Accomplishment
    end

    it "sets @work_experience to equal a WorkExperience record" do
      expect(assigns(:work_experience)).to eq(exp) 
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:exp) {Fabricate(:work_experience, user: alice)}
    let(:accomplishment) {Fabricate.attributes_for(:accomplishment, work_experience_id: exp.id)}
    
    before do 
      set_current_user(alice)
      exp
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, {accomplishment: accomplishment, work_experience_id: exp.id}}
    end

    context "with valid inputs" do 
      before do 
        xhr :post, :create, {accomplishment: accomplishment, work_experience_id: exp.id}
      end

      it "should save the work experience" do 
        expect(Accomplishment.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(Accomplishment.first.work_experience).to eq(exp)
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do    
      before do 
        set_current_user(alice)
        xhr :post, :create, {accomplishment: Fabricate.attributes_for(:accomplishment, body: nil), 
          work_experience_id: exp.id}
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
    let(:accomplishment){Fabricate(:accomplishment, work_experience: experience)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, {id: accomplishment.id, work_experience_id: experience.id}}
    end
    
    before do 
      set_current_user(alice)
      experience
      xhr :get, :edit, {work_experience_id: experience.id, id: accomplishment.id}
    end

    it "sets @experience to the correct work_experience" do 
      expect(assigns(:work_experience)).to eq(experience)
    end

    it "sets @experience to the correct work_experience" do 
      expect(assigns(:accomplishment)).to eq(accomplishment)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience){Fabricate(:work_experience, user: alice)}
    let(:accomplishment){Fabricate(:accomplishment, work_experience: experience)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, {work_experience_id: experience.id, id: accomplishment.id, accomplishment: {body: "SUPERMAN"}}}
    end

    context "with INVALID inputs" do 
      before do 
        set_current_user(alice)
        experience   
        xhr :put, :update, {work_experience_id: experience.id, id: accomplishment.id, accomplishment: {body: nil}}
      end

      it "save the updates made on the object" do 
        expect(Accomplishment.last.body).to eq("Title")
      end

      it "renders the update template" do
        expect(response).to render_template :update
      end
    end

    context "with VALID inputs" do 
      before do 
        set_current_user(alice)
        experience   
        xhr :put, :update, {work_experience_id: experience.id, id: accomplishment.id, accomplishment: {body: "SUPERMAN"}}
      end

      it "save the updates made on the object" do 
        expect(Accomplishment.last.body).to eq("SUPERMAN")
      end
      it "renders the update template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience) {Fabricate(:work_experience, user: alice)}
    let(:accomplishment1){Fabricate(:accomplishment, work_experience: experience)}
    let(:accomplishment2){Fabricate(:accomplishment, work_experience: experience)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, {id: accomplishment1.id, work_experience_id: experience.id}}
    end
    
    before do 
      set_current_user(alice)
      experience
      accomplishment1
      accomplishment2
      xhr :delete, :destroy, {id: accomplishment1.id, work_experience_id: experience.id}
    end

    it "deletes the experience" do 
      expect(Accomplishment.count).to eq(1)
    end

    it "renders the destroy template" do
      expect(response).to render_template :destroy
    end
  end
end