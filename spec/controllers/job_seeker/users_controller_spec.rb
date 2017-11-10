require 'spec_helper'

describe JobSeeker::WorkExperiencesController do 
  describe "GET show" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    before do 
      set_current_user(alice)
      xhr :get, :new
    end

    it "set @user to the current_user" do
      expect(assigns(:user)).to eq(alice)
    end

    it "sets @user_avatar to be current_user profile picture" do
      expect(assigns(:user)).to eq(alice)
    end

    it "sets @social_links to current_user social links" do
      expect(response).to render_template :new
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
      xhr :get, :edit, id: alice.id
    end

    it "sets @user to the current_user" do 
      expect(assigns(:user)).to eq(alice)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: alice.id}
    end

    before do 
      set_current_user(alice)
      experience   
      xhr :put, :update, id: experience.id, user: {first_name: "Screened"}
    end

    it "save the updates made on the object" do 
      expect(User.last.first_name).to eq("Screened")
    end
  end

end