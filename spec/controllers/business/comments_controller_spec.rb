require 'spec_helper' 

describe Business::CommentsController do 
  let(:company) {Fabricate(:company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:job) {Fabricate(:job, company: company)}
  let(:candidate) {Fabricate(:candidate, company: company)}
  let(:candidate1) {Fabricate(:candidate, company: company)}
  let(:application) {Fabricate(:application, candidate_id: candidate.id, job_id: job.id)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:client){Fabricate(:client, company: company)}
  let(:application_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id, job_id: job.id)}
  let(:candidate_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id)}
  let(:job_comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}
  let(:client_comment) {Fabricate(:comment, commentable_type: "Client", commentable_id: client.id)}
  
  before do  
    set_current_user(alice)
    set_current_company(company)
    job_board
    job
    client
    candidate
    client_comment
    candidate_comment
    job_comment
    application_comment
  end

  describe "GET job_comments" do 
    before do  
      xhr :get, :job_comments, job_id: job.id
    end
    
    it "sets @comment to be a new instance of comment" do 
      expect(assigns(:comment)).to be_new_record 
      expect(assigns(:comment)).to be_instance_of Comment
    end

    it "sets the @comments to the current Job" do 
      expect(assigns[:job]).to eq(job)
    end

    it "sets the @comments to the current Job" do 
      expect(assigns[:comments].count).to eq(1)
      expect(assigns[:comments]).to eq([job_comment])
    end
  end

  describe "GET client_comments" do 
    before do  
      xhr :get, :client_comments, client_id: client.id
    end
    
    it "sets @comment to be a new instance of comment" do 
      expect(assigns(:comment)).to be_new_record 
      expect(assigns(:comment)).to be_instance_of Comment
    end

    it "sets the @comments to the current client" do 
      expect(assigns[:client]).to eq(client)
    end

    it "sets the @comments to the current Job" do 
      expect(assigns[:comments].count).to eq(1)
      expect(assigns[:comments]).to eq([client_comment])
    end
  end

  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :index}
    end

    context "get APPLICATION comments" do 
      before do  
        xhr :get, :index, job: job.id, candidate_id: candidate.id
      end 

      it "sets the @comments to the current Candidate" do 
        expect(assigns[:comments]).to eq([application_comment])
        expect(assigns[:comments].count).to eq(1)
      end

      it "expects the response to render index template" do
        expect(response).to render_template :index
      end
    end

    context "get CANDIDATE comments" do 
      before do  
        xhr :get, :index, candidate_id: candidate.id
      end 

      it "sets the @comments to the current Candidate" do 
        expect(assigns[:comments]).to eq([application_comment, candidate_comment])
        expect(assigns[:comments].count).to eq(2)
      end

      it "expects the response to render index template" do
        expect(response).to render_template :index
      end
    end
  end

  describe "GET new" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :index}
    end

    context "adding a new CANDIDATE comment" do 
      before do 
        xhr :get, :new, candidate_id: candidate.id
      end

      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets @commentable to an instance of current company" do 
        expect(assigns(:commentable)).to eq(candidate)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end
    context "adding a new Application comment" do 
      before do 
        xhr :get, :new, candidate_id: candidate.id, job: job.id
      end

      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets @commentable to an instance of current company" do 
        expect(assigns(:commentable)).to eq(candidate)
        expect(assigns(:job)).to eq(job)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "adding a new JOB comment" do 
      before do 
        xhr :get, :new, job_id: job.id
      end

      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets @commentable to an instance of current company" do 
        expect(assigns(:commentable)).to eq(job)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "adding a new CLIENT comment" do 
      before do 
        xhr :get, :new, client_id: client.id
      end

      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets @commentable to an instance of current company" do 
        expect(assigns(:commentable)).to eq(client)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do  
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :index}
    end

    context "creates a JOB comment" do
      before do  
        xhr :post, :create, job_id: job.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Job", commentable_id: job.id, user_id: alice.id)
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(5)
      end

      it "associates the comment to the correct records" do
        expect(Comment.last.commentable).to eq(job)
        expect(job.comments.count).to eq(2)
      end

      it "assigns comments to the correct comments for application" do 
        expect(assigns[:comments]).to eq([Comment.last, job_comment] )
        expect(assigns[:comments].count).to eq(2)
      end

      it "creates an activity related to the comment" do 
        expect(Activity.count).to eq(1)
        expect(Comment.last.activity).to be_present
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "creates a CANDIDATE comment" do
      before do  
        xhr :post, :create, candidate_id: candidate.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Candidate", commentable_id: candidate.id, user_id: alice.id)
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(5)
      end

      it "associates the comment to the correct records" do
        expect(Comment.last.commentable).to eq(candidate)
        expect(candidate.comments.count).to eq(3)
      end

      it "assigns comments to the correct comments for candidate" do 
        expect(assigns[:comments].count).to eq(3)
        expect(assigns[:comments]).to eq([Comment.last, application_comment, candidate_comment])
      end

      it "creates an activity related to the comment" do 
        expect(Activity.count).to eq(1)
        expect(Comment.last.activity).to be_present
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "creates an APPLICATION comment" do
      before do  
        xhr :post, :create, candidate_id: candidate.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Candidate", commentable_id: candidate.id, user_id: alice.id, job_id: job.id)
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(5)
      end

      it "associates the comment to the correct records" do
        expect(Comment.last.commentable).to eq(candidate)
        expect(Comment.last.job_id).to eq(job.id)
      end

      it "assigns comments to the correct comments for application" do 
        expect(assigns[:comments]).to eq([application_comment, Comment.last])
        expect(assigns[:comments].count).to eq(2)
      end

      it "creates an activity related to the comment" do 
        expect(Activity.count).to eq(1)
        expect(Comment.last.activity).to be_present
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "creates an CLIENT comment" do
      before do  
        xhr :post, :create, client_id: client.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Client", commentable_id: client.id, user_id: alice.id)
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(5)
      end

      it "associates the comment to the correct records" do
        expect(Comment.last.commentable).to eq(client)
      end

      it "assigns comments to the correct comments for application" do 
        expect(assigns[:comments]).to eq([client_comment, Comment.last])
        expect(assigns[:comments].count).to eq(2)
      end

      it "creates an activity related to the comment" do 
        expect(Activity.count).to eq(1)
        expect(Comment.last.activity).to be_present
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "With Invalid Inputs" do
      before do  
        xhr :post, :create, client_id: client.id, comment: Fabricate.attributes_for(:comment, body: nil, commentable_type: "Client", commentable_id: client.id, user_id: alice.id)
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
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: job_comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: job_comment.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: job_comment.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: job_comment.id}
    end
    
    context "@comment belongs to the company through commentable" do 
      before do  
        xhr :get, :edit, id: job_comment.id
      end
      
      it "sets @comment to the correct comment" do 
        expect(assigns(:comment)).to eq(job_comment)
      end

      it "sets @commentable to the correct parent" do
        expect(assigns(:commentable)).to eq(job)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: job_comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: job_comment.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: job_comment.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: job_comment.id}
    end

    context "with valid inputs" do
      before do 
        xhr :put, :update, id: client_comment.id, comment: {body: "Thomas Johnson"}
      end

      it "updates the comment" do 
        expect(Comment.first.body).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        xhr :put, :update, id: job_comment.id, comment: {body: nil}
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "sets the @email_signature to the current_user" do 
        expect(job_comment.body).to eq(job_comment.body)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    before do  
      xhr :delete, :destroy, id: job_comment.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: job_comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { xhr :delete, :destroy, id: job_comment.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { xhr :delete, :destroy, id: job_comment.id}
    end

    it "destroys the correct instance of the candidate" do 
      expect(Comment.count).to eq(3)
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end

  describe "POST create multiple" do 
    context "create multiple CANDIDATE comments" do
      before do 
        @candidate1 = Fabricate(:candidate, company: company)
        @candidate2 = Fabricate(:candidate, company: company)
        @candidate3 = Fabricate(:candidate, company: company)
        xhr :post, :add_note_multiple, comment: Fabricate.attributes_for(:comment, user_id: alice.id), applicant_ids: "#{@candidate1.id}, #{@candidate2.id}, #{@candidate3.id}"
      end

      it "creates the comment" do
        expect(Comment.count).to eq(7)
      end

      it "associates the comment to the correct records" do
        expect(@candidate1.comments.count).to eq(1)
        expect(@candidate2.comments.count).to eq(1)
        expect(@candidate3.comments.count).to eq(1)
        expect(Activity.count).to eq(3)
      end

      it "renders the new action" do 
        expect(response).to render_template :add_note_multiple
      end
    end

    context "create multiple APPLICATION comments" do
      before do 
        @candidate1 = Fabricate(:candidate, company: company)
        @candidate2 = Fabricate(:candidate, company: company)
        @candidate3 = Fabricate(:candidate, company: company)
        xhr :post, :add_note_multiple, comment: Fabricate.attributes_for(:comment, user_id: alice.id, job_id: job.id), applicant_ids: "#{@candidate1.id}, #{@candidate2.id}, #{@candidate3.id}"
      end

      it "creates the comment" do
        expect(Comment.count).to eq(7)
      end

      it "associates the comment to the correct records" do
        expect(@candidate1.comments.count).to eq(1)
        expect(@candidate2.comments.count).to eq(1)
        expect(@candidate3.comments.count).to eq(1)
        expect(Activity.count).to eq(3)
      end

      it "renders the new action" do 
        expect(response).to render_template :add_note_multiple
      end
    end
  end
end