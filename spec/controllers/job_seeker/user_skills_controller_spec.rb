require 'spec_helper'

describe JobSeeker::UserSkillsController do 
  describe "GET new" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience) {Fabricate(:work_experience, user: alice)}
    let(:skill){Fabricate(:skill)}
    

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, {work_experience_id: experience.id}}
    end

    before do 
      set_current_user(alice)
      experience
      xhr :get, :new, {work_experience_id: experience.id}
    end

    it "set @experience to be a new instance of WorkExperience" do
      expect(assigns(:user_skill)).to be_new_record 
      expect(assigns(:user_skill)).to be_instance_of UserSkill
    end

    it "sets work_experience to equal the related WorkExperience object" do
      expect(assigns(:work_experience)).to eq(experience)
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience) {Fabricate(:work_experience, user: alice)}
    let(:skill){Fabricate(:skill)}
    let(:user_skill){Fabricate.attributes_for(:user_skill, work_experience_id: experience.id, 
      skill_id: skill.id, user_id: alice.id)}
    
    before do 
      set_current_user(alice)
      experience
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, {name: "Rails", work_experience_id: experience.id}}
    end

    context "with valid inputs and skill DOES exists" do 
      before do 
        xhr :post, :create, {name: "Rails" , work_experience_id: experience.id}
      end

      it "should save the work experience" do 
        expect(UserSkill.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(UserSkill.first.work_experience).to eq(experience)
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with valid inputs and skill DOES NOT exists" do 
      before do 
        xhr :post, :create, {name: "Rails", work_experience_id: experience.id}
      end

      it "should save the UserSkill" do 
        expect(UserSkill.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(UserSkill.first.work_experience).to eq(experience)
      end

      it "associates the work experience with the current_user" do
        expect(Skill.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(Skill.first.name).to eq('Rails')
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do    
      before do 
        set_current_user(alice)
        xhr :post, :create, {name: '', work_experience_id: experience.id}
      end

      it "redirects to the profile index page" do 
        expect(response).to render_template :create
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "DELETE destroy" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:experience) {Fabricate(:work_experience, user: alice)}
    let(:skill){Fabricate(:skill)}
    let(:skill1){Fabricate(:skill)}
    let(:user_skill){Fabricate(:user_skill, work_experience_id: experience.id, skill_id: skill.id, user_id: alice.id)}
    let(:user_skill1){Fabricate(:user_skill, work_experience_id: experience.id, skill_id: skill1.id, user_id: alice.id)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, {id: user_skill.id, work_experience_id: experience.id}}
    end
    
    before do 
      set_current_user(alice)
      skill
      user_skill1
      user_skill
      xhr :delete, :destroy, {id: user_skill.id, work_experience_id: experience.id}
    end

    it "deletes the experience" do 
      expect(UserSkill.count).to eq(1)
    end

    it "renders the destroy template" do
      expect(response).to render_template :destroy
    end
  end
end