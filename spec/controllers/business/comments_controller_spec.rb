require 'spec_helper' 

describe Business::CommentsController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}
    let(:candidate1) {Fabricate(:candidate, company: company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:application_comment) {Fabricate(:comment, commentable_type: "Application", commentable_id: application.id)}
    let(:candidate_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id)}
    let(:job_comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}
      
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :index}
    end

    

    context "@job in params renders job.comments" do 
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        candidate_comment
        job_comment
        xhr :get, :index, job_id: job.id
      end
      
      it "sets the @comments to the current Job" do 
        expect(job.comments.count).to eq(1)
      end

      it "sets the @comments to the current Job" do 
        expect(job.comments.first.body).to eq(job_comment.body)
      end

      it "only renders candidates that belong to Job" do
        expect(job.comments.first).to eq(job_comment)
      end
    end

    context "@candidate in params" do 
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        candidate_comment
        job_comment
        xhr :get, :index, candidate_id: candidate.id
      end
      

      it "sets the @comments to the current Candidate" do 
        expect(candidate.comments.count).to eq(1)
      end
      it "sets the @comments to the current Job" do 
        expect(candidate.comments.first.body).to eq(candidate_comment.body)
      end

      it "only renders candidates that belong to Candidate" do
        expect(candidate.comments.first).to eq(candidate_comment)
      end
    end
  end

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}
    let(:candidate1) {Fabricate(:candidate, company: company)}
    let(:application){Fabricate(:application, job: job, candidate: candidate)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new}
    end

    context "@job is in t in params" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        xhr :get, :new, job_id: job.id
      end
      
      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end

      it "sets @commentable to an instance of Job" do 
        expect(assigns(:commentable)).to eq(job)
      end
    end
   
    context "application_id in params" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        xhr :get, :new, application_id: application.id
      end

      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets @commentable to an instance of candidate" do 
        expect(assigns(:commentable)).to eq(application)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "candidate_id in params" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        xhr :get, :new, candidate_id: candidate.id
      end

      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets @commentable to an instance of candidate" do 
        expect(assigns(:commentable)).to eq(candidate)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do  
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}
    let(:candidate1) {Fabricate(:candidate, company: company)}
    let(:application){Fabricate(:application, job: job, candidate: candidate)}
    let(:comment) {Fabricate.attributes_for(:comment, user: alice)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create}
    end

    context "@job is in params" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        xhr :post, :create, comment: comment, job_id: job.id
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(1)
      end

      it "associates the comment to the correct records" do
        expect(Comment.first.commentable).to eq(job)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "@candidate is in params" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        xhr :post, :create, comment: comment, candidate_id: candidate.id
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(1)
      end

      it "associates the comment to the correct records" do
        expect(Comment.first.commentable).to eq(candidate)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "@application is in params" do
      before do  
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        application
        xhr :post, :create, comment: comment, application_id: application.id
      end
      
      it "creates the comment" do
        expect(Comment.count).to eq(1)
      end

      it "associates the comment to the correct records" do
        expect(Comment.first.commentable).to eq(application)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end
  end
  
  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}
    let(:candidate1) {Fabricate(:candidate, company: company)}
    let(:application){Fabricate(:application, job: job, candidate: candidate)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:application_comment) {Fabricate(:comment, commentable_type: "Application", commentable_id: application.id)}
    let(:candidate_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id)}
    let(:job_comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}
      
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: job_comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: job_comment.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: job_comment.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      candidate
      candidate_comment
      application_comment
      job_comment
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

  describe "PUT update" do 
    context "with valid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      let(:candidate) {Fabricate(:candidate, company: company)}
      let(:candidate1) {Fabricate(:candidate, company: company)}
      let(:application){Fabricate(:application, job: job, candidate: candidate)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}

      before do 
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        candidate
        comment
        xhr :put, :update, id: comment.id, comment: {body: "Thomas Johnson"}
      end

      it "updates the comment" do 
        expect(Comment.last.body).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      let(:company) {Fabricate(:company)}
      let(:alice) {Fabricate(:user, company: company, role: "Admin")}
      let(:job) {Fabricate(:job, company: company)}
      let(:candidate) {Fabricate(:candidate, company: company)}
      let(:candidate1) {Fabricate(:candidate, company: company)}
      let(:application){Fabricate(:application, job: job, candidate: candidate)}
      let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
      let(:comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}

      before do 
        set_current_user(alice)
        set_current_company(company)
        job_board
        job
        comment
        xhr :put, :update, id: comment.id, comment: {body: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(Comment.first.body).to eq(comment.body)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company)}
    let(:candidate) {Fabricate(:candidate, company: company)}
    let(:candidate1) {Fabricate(:candidate, company: company)}
    let(:application){Fabricate(:application, job: job, candidate: candidate)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:application_comment) {Fabricate(:comment, commentable_type: "Application", commentable_id: application.id)}
    let(:candidate_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id)}
    let(:job_comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}

    before do  
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      candidate
      candidate_comment
      application_comment
      job_comment
      xhr :delete, :destroy, id: application_comment.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: application_comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { xhr :delete, :destroy, id: application_comment.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { xhr :delete, :destroy, id: application_comment.id}
    end

    it "destroys the correct instance of the candidate" do 
      expect(Comment.count).to eq(2)
    end

    it "destroys the correct instance of the candidate" do 
      expect(Comment.all).to eq([candidate_comment, job_comment])
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end
end