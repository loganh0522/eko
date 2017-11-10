require 'spec_helper' 

describe Business::UserAvatarsController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, id: alice.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, id: alice.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, id: alice.id}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new, id: alice.id
    end

    it "sets the @user_avatar to a new instance of UserAvatar " do 
      expect(assigns(:user_avatar)).to be_new_record 
      expect(assigns(:user_avatar)).to be_instance_of UserAvatar
    end

    it "expects the response to render new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, user_id: alice.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, user_id: alice.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, user_id: alice.id}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:avatar) {Fabricate.attributes_for(:user_avatar, user: alice)}

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :post, :create, user_id: alice.id, user_avatar: avatar
    end

    it "expects the response to render create template" do
      expect(response).to render_template :create
    end
    
    it "creates the users avatar" do
      expect(UserAvatar.count).to eq(1)
    end

    it "associates the user_avatar to current_user" do
      expect(UserAvatar.first.user).to eq(alice)
    end

    it "sets the @user_avatar to a new instance of UserAvatar " do 
      expect(assigns(:new_avatar)).to be_new_record 
      expect(assigns(:new_avatar)).to be_instance_of UserAvatar
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:avatar){Fabricate(:user_avatar, user_id: alice.id)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: avatar.id, user_id: alice.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: avatar.id, user_id: alice.id}
    end
    
    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: avatar.id, user_id: alice.id}
    end

    before do 
      set_current_company(company)
      set_current_user(alice)
    end

    it "sets the @user to the current_user" do 
      xhr :get, :edit, id: avatar.id, user_id: alice.id
      expect(assigns(:user_avatar)).to eq(avatar)
    end

    it "expects the response to render edit template" do
      xhr :get, :edit, id: avatar.id, user_id: alice.id
      expect(response).to render_template :edit
    end
  end

  describe "POST update" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin", email: 'email')}
    let(:avatar){Fabricate(:user_avatar, user_id: alice.id)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: avatar.id, user_id: alice.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: avatar.id, user_id: alice.id}
    end
    
    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: avatar.id, user_id: alice.id}
    end

    before do 
      set_current_company(company)
      set_current_user(alice)
    end

    context "with valid inputs" do
      before do  
        xhr :put, :update, id: avatar.id, user_id: alice.id, user_avatar: {image: "file_name"}
      end

      it "render's the update action" do 
        expect(response).to render_template :update
      end
    end
  end
end