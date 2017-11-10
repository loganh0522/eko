require 'spec_helper'

describe JobSeeker::BackgroundImagesController do 
  # describe "GET new" do 
  #   let(:alice){Fabricate(:user, kind: 'job seeker')}
    
  #   it_behaves_like "requires sign in" do
  #     let(:action) {xhr :get, :new}
  #   end

  #   before do 
  #     set_current_user(alice)
  #     xhr :get, :new
  #   end

  #   it "set @background to be a new instance of Workbackground" do
  #     expect(assigns(:background)).to be_new_record 
  #     expect(assigns(:background)).to be_instance_of Workbackground
  #   end

  #   it "renders the new template" do
  #     expect(response).to render_template :new
  #   end
  # end

  describe 'POST create' do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:background) {Fabricate.attributes_for(:background_image, user: alice)}
    
    before do 
      set_current_user(alice)
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, background_image: background}
    end

    context "with valid inputs" do 
      before do 
        xhr :post, :create, background_image: background
      end

      it "should save the work background" do 
        expect(BackgroundImage.count).to eq(1)
      end

      it "should save the background image" do 
        expect(BackgroundImage.file).to eq(background.file)
      end

      it "associates the work background with the current_user" do
        expect(BackgroundImage.first.user).to eq(alice)
      end

      it "redirects to the profile index action" do 
        expect(response).to render_template :create
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      
      before do 
        set_current_user(alice)
        xhr :post, :create, background_image: {file: nil} 
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
    let(:background){Fabricate(:background_image, user: alice)}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: background.id}
    end
    
    before do 
      set_current_user(alice)
      background
      xhr :get, :edit, id: background.id
    end

    it "sets @background to the correct work_background" do 
      expect(assigns(:background)).to eq(background)
    end
    
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:background){Fabricate(:background_image, user: alice)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: background.id}
    end

    before do 
      set_current_user(alice)
      background   
      xhr :put, :update, id: background.id, background_image: {file: "steve"}
    end

    it "save the updates made on the object" do 
      expect(BackgroundImage.last.file).to eq("steve")
    end
  end

  describe "DELETE destroy" do 
    let(:alice){Fabricate(:user, kind: 'job seeker')}
    let(:background) {Fabricate(:background_image, user: alice)}
    let(:background2) {Fabricate(:background_image, user: alice)}
    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: background.id}
    end
    
    before do 
      set_current_user(alice)
      background
      background2
      xhr :delete, :destroy, id: background.id   
    end

    it "deletes the background" do 
      expect(BackgroundImage.count).to eq(1)
    end
  end
end