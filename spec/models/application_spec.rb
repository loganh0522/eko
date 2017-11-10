require 'spec_helper'

describe Application do 
  it { should belong_to(:applicant) }
  it { should belong_to(:apps) }
  it { should belong_to(:stage)}

  context "With multiple options submitted" do 
    it "should return an empty array if the title does not have a match" do 
      logan = User.create(first_name: "Logan", last_name: "houston")
      patriot = Application.create(title: "Patriot", description: "Movie about the American Revolution")
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever")
      expect(Video.search_by_title("Thor")).to eq([])

      it_behaves_like "requires sign in" do
        let(:action) {get :index}
      end

      it_behaves_like "user does not belong to company" do 
        let(:action) {get :index}
      end

      it_behaves_like "company has been deactivated" do
        let(:action) {get :index}
      end

      it "sets the @jobs to the job postings that belong to the current company" do 
        company = Fabricate(:company)
        alice = Fabricate(:user, company: company)
        logan = Fabricate(:user, kind: 'job seeker')
        set_current_user(alice)
        set_current_company(company)
        job = Fabricate(:job, company: company) 
        application = Fabricate(:application, job: job, user: logan, company: company)
        
 
    
        expect(assigns(:jobs)).to eq([sales_rep1])
      end

    end 

  end
end