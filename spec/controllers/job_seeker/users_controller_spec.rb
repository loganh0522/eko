require 'spec_helper'

describe JobSeeker::UsersController do 
  describe "GET show" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:avatar){Fabricate(:user_avatar, user: alice)}
    let(:background){Fabricate(:background_image, user: alice)}
    let(:experience){Fabricate(:work_experience, user: alice)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    before do 
      set_current_user(alice)
      avatar
      background
      experience
      xhr :get, :show
    end

    it "set @user to the current_user" do
      expect(assigns(:user)).to eq(alice)
    end

    it "sets @user_avatar to be current_user profile picture" do
      expect(assigns(:avatar)).to eq(avatar)
    end

    it "sets @background_image to be current_user profile picture" do
      expect(assigns(:background)).to eq(background)
    end

    it "sets @background_image to be current_user profile picture" do
      expect(assigns(:work_experiences)).to eq([experience])
      expect(assigns(:work_experiences)).to match_array([experience])
    end
  end

  describe "GET edit" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: alice.id}
    end
    
    before do 
      set_current_user(alice)
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

    context "it updates the users information" do 
      before do 
        set_current_user(alice)
        xhr :put, :update, id: alice.id, user: {first_name: "Screened", location: "Toronto, On, Canada"}
      end

      it "save the updates made on the object" do 
        expect(User.first.first_name).to eq("Screened")
      end

      it "renders the update template" do
        expect(response).to render_template :update
      end
    end

    context "it updates the users information" do 
      let(:alice){Fabricate(:user, kind: 'job seeker', first_name: "Screened")}

      before do 
        set_current_user(alice)
        xhr :put, :update, id: alice.id, user: {first_name: nil}
      end
      
      it "does not update the work_experience" do 
        expect(User.first.first_name).to eq("Screened")
      end
      
      it "redirects to the profile index page" do 
        expect(response).to render_template :update
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end
end