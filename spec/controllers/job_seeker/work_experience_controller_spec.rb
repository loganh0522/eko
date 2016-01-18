require 'spec_helper'

describe JobSeeker::WorkExperiencesController do 
  describe 'POST create' do 
    it_behaves_like "requires sign in" do 
      let(:action) {post :create} 
    end

    it_behaves_like "user is not a job seeker" do
      let(:action) {post :create}
    end

    context "with valid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}

      before do 
        set_current_user(alice)
        post :create, work_experience: Fabricate.attributes_for(:work_experience), user: alice
      end

      it "should save the work experience" do 
        expect(WorkExperience.count).to eq(1)
      end

      it "associates the work experience with the current_user" do
        expect(WorkExperience.first.user).to eq(alice)
      end

      it "redirects to the profile index page" do 
        expect(response).to redirect_to job_seeker_profiles_path
      end
    end

    context "with invalid inputs" do 
      let(:alice){Fabricate(:user, kind: 'job seeker')}
      
      before do 
        set_current_user(alice)
        post :create, work_experience: {title: 'title'}, user: alice
      end

      it "redirects to the profile index page" do 
        expect(response).to redirect_to job_seeker_profiles_path
      end

      it "sets the flash message" do 
        expect(flash[:error]).to be_present
      end
    end
  end
end