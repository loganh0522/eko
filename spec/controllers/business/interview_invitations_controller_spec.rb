require 'spec_helper'

describe Business::InterviewInvitationsController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:joe) {Fabricate(:user, company: company)}
    let(:bro) {Fabricate(:user)}

    before do  
      set_current_user(alice)
      set_current_company(company)
      xhr :get, :new
    end
    
    it "set @invitation to be a new instance of Tags" do
      expect(assigns(:invitation)).to be_new_record 
      expect(assigns(:invitation)).to be_instance_of InterviewInvitation
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Admin")}
    let(:candidate) {Fabricate(:candidate, company: company)}
    let(:candidate2) {Fabricate(:candidate, company: company)}
    let(:job) {Fabricate(:job, company: company)}

    let(:invitation) {Fabricate.attributes_for(:interview_invitation, 
      company: company, candidate_ids: candidate.id, user_ids: alice.id, 
      interview_times_attributes: {"0" => {date: "2017-07-19", time: "10:30am"}})}

    let(:multiple_invitations) {Fabricate.attributes_for(:interview_invitation, 
      company: company, candidate_ids: "#{candidate.id}, #{candidate2.id}", user_ids: "#{alice.id}, #{bob.id}", 
      interview_times_attributes: {"0" => {date: "2017-07-19", time: "10:30am"}})}
    
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    context "creates invitation w correct parameters" do
      before do  
        ActionMailer::Base.deliveries.clear 
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, interview_invitation: invitation
      end

      it "creates the interview invitation" do
        expect(InterviewInvitation.count).to eq(1)
      end
      
      it "assigns the candidate to the interview invitation" do 
        expect(InvitedCandidate.count).to eq(1)
      end

      it "assigns the correct candidate to the interview invitation" do 
        expect(InterviewInvitation.first.candidates.first).to eq(candidate)
      end
      
      it "assigns a user to the interview invitation" do   
        expect(AssignedUser.count).to eq(1)
      end

      it "assigns the correct user to the interview invitation" do   
        expect(InterviewInvitation.first.users.first).to eq(alice)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "sends out an email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([candidate.email])
      end

      it "expect email count to equal 1" do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end

      it "creates interview time for invitation" do 
        expect(InterviewTime.count).to (eq(1))
      end

      it "creates the proper interview times" do 
        expect(InterviewTime.first.time).to eq("10:30am")
      end

      it "associates the time with invitation" do 
        expect(InterviewInvitation.first.interview_times.first.time).to eq("10:30am")
        expect(InterviewInvitation.first.interview_times.first.date).to eq("2017-07-19")
      end
    end

    context "creates invitation with multiple candidates and users" do
      before do  
        ActionMailer::Base.deliveries.clear 
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, interview_invitation: multiple_invitations
      end

      it "creates the interview invitation" do
        expect(InterviewInvitation.count).to eq(1)
      end
      
      it "assigns the candidate to the interview invitation" do 
        expect(InvitedCandidate.count).to eq(2)
      end

      it "assigns the correct candidate to the interview invitation" do 
        expect(InterviewInvitation.first.candidates).to eq([candidate, candidate2])
      end
      
      it "assigns a user to the interview invitation" do   
        expect(AssignedUser.count).to eq(2)
      end

      it "assigns the correct candidate to the interview invitation" do 
        expect(InterviewInvitation.first.users).to eq([alice, bob])
      end

      it "expect email count to equal 1" do
        expect(ActionMailer::Base.deliveries.count).to eq(2)
      end
    end

    context "it does not create invitation w Invalid parameters" do
      before do 
        ActionMailer::Base.deliveries.clear  
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, interview_invitation: Fabricate.attributes_for(:interview_invitation, company: company, 
          candidate_ids: "", user_ids: alice.id)
      end

      it "creates the interview invitation" do
        expect(InterviewInvitation.count).to eq(0)
      end
      
      it "assigns the candidate to the interview invitation" do 
        expect(InvitedCandidate.count).to eq(0)
      end
      
      it "assigns a user to the interview invitation" do   
        expect(AssignedUser.count).to eq(0)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "sends out an email to the email address" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    context "it does not create invitation w Invalid parameters" do
      before do  
        ActionMailer::Base.deliveries.clear 
        set_current_user(alice)
        set_current_company(company)
        xhr :post, :create, interview_invitation: Fabricate.attributes_for(:interview_invitation, company: company, 
          candidate_ids: candidate.id, user_ids: "")
      end

      it "creates the interview invitation" do
        expect(InterviewInvitation.count).to eq(0)
      end
      
      it "assigns the candidate to the interview invitation" do 
        expect(InvitedCandidate.count).to eq(0)
      end
      
      it "assigns a user to the interview invitation" do   
        expect(AssignedUser.count).to eq(0)
      end

      it "it renders the create action template" do 
        expect(response).to render_template :create
      end

      it "sends out an email to the email address" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end