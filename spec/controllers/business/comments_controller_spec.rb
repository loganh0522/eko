require 'spec_helper' 

describe Business::CommentsController do 
  let(:company) {Fabricate(:company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:job) {Fabricate(:job, company: company)}
  let(:candidate) {Fabricate(:candidate, company: company)}
  let(:candidate1) {Fabricate(:candidate, company: company)}
  let(:application) {Fabricate(:application, candidate_id: candidate.id, job_id: job.id)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  
  let(:application_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id, job_id: job.id)}
  let(:candidate_comment) {Fabricate(:comment, commentable_type: "Candidate", commentable_id: candidate.id)}
  let(:job_comment) {Fabricate(:comment, commentable_type: "Job", commentable_id: job.id)}
  
  before do  
    set_current_user(alice)
    set_current_company(company)
    job_board
    job
    candidate
    candidate_comment
    job_comment
    application_comment
  end

  describe "GET job_comments" do 
    context "@job in params renders job.comments" do 
      before do  
        xhr :get, :job_comments, job_id: job.id
      end
      
      it "sets @comment to be a new instance of comment" do 
        expect(assigns(:comment)).to be_new_record 
        expect(assigns(:comment)).to be_instance_of Comment
      end

      it "sets the @comments to the current Job" do 
        expect(assigns[:comments].count).to eq(1)
        expect(assigns[:comments]).to eq([job_comment])
      end
    end
  end

  # describe "GET client_comments" do 
  #   context "@job in params renders job.comments" do 
  #     before do  
  #       xhr :get, :job_comments, job_id: job.id
  #     end
      
  #     it "sets the @comments to the current Job" do 
  #       expect(job.open_comments.count).to eq(2)
  #       expect(job.comments.first.title).to eq(job_comment.title)
  #       expect(assigns[:comments]).to eq([job_comment, application_comment])
  #     end
  #   end
  # end

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
        xhr :post, :create, job_id: job.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Job", commentable_id: job.id, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id, job_id: job.id)
      end
      
      it "creates the comment" do
        expect(comment.count).to eq(6)
      end

      it "associates the comment to the correct records" do
        expect(comment.last.commentable).to eq(job)
        expect(job.open_comments.count).to eq(3)
      end

      it "assigns comments to the correct comments for application" do 
        expect(assigns[:comments]).to eq([job_comment, application_comment, comment.last] )
        expect(assigns[:comments].count).to eq(3)
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "creates a CANDIDATE comment" do
      before do  
        xhr :post, :create, candidate_id: candidate.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Candidate", commentable_id: candidate.id, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id)
      end
      
      it "creates the comment" do
        expect(comment.count).to eq(6)
      end

      it "associates the comment to the correct records" do
        expect(comment.last.commentable).to eq(candidate)
        expect(candidate.comments.count).to eq(3)
      end

      it "assigns comments to the correct comments for application" do 
        expect(assigns[:comments].count).to eq(3)
        expect(assigns[:comments]).to eq([comment.last, application_comment, candidate_comment])
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "creates an APPLICATION comment" do
      before do  
        xhr :post, :create, candidate_id: candidate.id, comment: Fabricate.attributes_for(:comment, commentable_type: "Candidate", commentable_id: candidate.id, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id, job_id: job.id)
      end
      
      it "creates the comment" do
        expect(comment.count).to eq(6)
      end

      it "associates the comment to the correct records" do
        expect(comment.last.commentable).to eq(candidate)
        expect(comment.last.job_id).to eq(job.id)
      end

      it "assigns comments to the correct comments for application" do 
        expect(assigns[:comments]).to eq([comment.last, application_comment])
        expect(assigns[:comments].count).to eq(2)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    # context "creates an CLIENT comment" do
    #   before do  
    #     xhr :post, :create, comment: Fabricate.attributes_for(:comment, commentable_type: "Candidate", commentable_id: candidate.id, company: company, job_id: job.id), user_id: alice.id
    #   end
      
    #   it "creates the comment" do
    #     expect(comment.count).to eq(6)
    #   end

    #   it "associates the comment to the correct records" do
    #     expect(comment.last.commentable).to eq(client)
    #   end

    #   it "assigns comments to the correct comments for application" do 
    #     expect(assigns[:comments]).to eq([comment.last, client_comment])
    #     expect(assigns[:comments].count).to eq(2)
    #   end

    #   it "renders the new action" do 
    #     expect(response).to render_template :create
    #   end
    # end
  end
  
  describe "GET edit" do     
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: comment.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: comment.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: comment.id}
    end
    
    context "@comment belongs to the company through commentable" do 
      before do  
        xhr :get, :edit, id: comment.id
      end
      
      it "sets @comment to the correct comment" do 
        expect(assigns(:comment)).to eq(comment)
      end

      it "sets @commentable to the correct parent" do
        expect(assigns(:commentable)).to eq(company)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: comment.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: comment.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: comment.id}
    end

    context "with valid inputs" do
      before do 
        xhr :put, :update, id: comment.id, comment: {title: "Thomas Johnson"}
      end

      it "updates the comment" do 
        expect(comment.first.title).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        xhr :put, :update, id: comment.id, comment: {title: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(comment.first.title).to eq(comment.title)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    before do  
      xhr :delete, :destroy, id: comment.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: comment.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { xhr :delete, :destroy, id: comment.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { xhr :delete, :destroy, id: comment.id}
    end

    it "destroys the correct instance of the candidate" do 
      expect(comment.count).to eq(4)
    end

    it "renders the destroy template" do 
      expect(response).to render_template :destroy
    end
  end

  describe "POST create multiple" do 
    before do 
      @candidate1 = Fabricate(:candidate, company: company)
      @candidate2 = Fabricate(:candidate, company: company)
      @candidate3 = Fabricate(:candidate, company: company)
      xhr :post, :create_multiple, comment: Fabricate.attributes_for(:comment, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id, job_id: job.id), applicant_ids: "#{@candidate1.id}, #{@candidate2.id}, #{@candidate3.id}"
    end

    it "creates the comment" do
      expect(comment.count).to eq(8)
    end

    it "associates the comment to the correct records" do
      expect(@candidate1.comments.count).to eq(1)
      expect(@candidate2.comments.count).to eq(1)
      expect(@candidate3.comments.count).to eq(1)
    end

    it "renders the new action" do 
      expect(response).to render_template :create_multiple
    end
  end

  describe "POST completed" do 
    before do 
      xhr :post, :completed, id: comment.id
    end

    it "destroys the correct instance of the candidate" do 
      expect(comment.first.status).to eq('complete')
      expect(comment.first.completed_by_id).to eq(alice.id)
    end

    it "renders the complete template" do 
      expect(response).to render_template :completed
    end
  end
end