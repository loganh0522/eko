require 'spec_helper' 

describe Business::QuestionsController do 
  describe "GET index" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      get :index, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index, job_id: job.id}
    end

    context "when user belongs to current_company" do
      it "sets the @jobs to the job postings that belong to the current company" do    
        expect(assigns(:job)).to eq(job)
      end

      it "expects to return the correct number of job postings" do 
        expect(Job.count).to eq(1)
      end

      it "expects to return the associated quesitons of the job posting" do 
        expect(Question.count).to eq(0)
      end
    end
  end

  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      xhr :get, :new, job_id: job.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :new, job_id: job.id}
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end
    
    it "set @question to be a new instance of Questions" do
      expect(assigns(:question)).to be_new_record 
      expect(assigns(:question)).to be_instance_of Question
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:question) {Fabricate.attributes_for(:question, job_id: job.id)}
    let(:option) {Fabricate(:question_option, question_id: question.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
    end
   
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, question: question, job_id: job.id}
    end

    context "with valid input" do 
      before do 
        xhr :post, :create, question: question, job_id: job.id
      end

      it "creates the question" do 
        expect(Question.count).to eq(1)
      end

      it "associates the question with the job" do 
        expect(Question.first.job).to eq(job)
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end
    end
    
    context "with VALID nested attributes for options" do 
      before do 
        xhr :post, :create, job_id: job.id, question: {job_id: job.id, kind: "Checkbox", body: "Question 1", question_options_attributes: {"0" => {body: "Answer 1", _destroy: "false"}, "1" => {body: "Answer 2", _destroy: "false"}}}
      end

      it "creates the question" do 
        expect(Question.count).to eq(1)
      end

      it "creates the question Option" do 
        expect(QuestionOption.count).to eq(2)
        expect(QuestionOption.first.body).to eq("Answer 1")
      end

      it "associates the option with the question" do 
        expect(QuestionOption.first.question).to eq(Question.first)
      end

      it "associates the question with the job" do 
        expect(Question.first.job).to eq(job)
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end
    end

    context "with INVALID nested attributes for options" do 
      before do 
        xhr :post, :create, job_id: job.id, question: {job_id: job.id, kind: "Checkbox", body: "Question 1", question_options_attributes: {"0" => {body: "", _destroy: "false"}, "1" => {body: "Answer 2", _destroy: "false"}}}
      end

      it "creates the question" do 
        expect(Question.count).to eq(0)
      end

      it "creates the question Option" do 
        expect(QuestionOption.count).to eq(0)
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end
    end

    context "without INVALID input" do 
      before do 
        xhr :post, :create, question: {job_id: job.id , body: nil}, job_id: job.id
      end

      it "does not create the question" do 
        expect(Question.count).to eq(0)
      end

      it "renders the create template" do
        expect(response).to render_template :create
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:question) {Fabricate(:question, job_id: job.id)}
    
    before do 
      set_current_user(alice)
      set_current_company(company)
      job_board
      job
      xhr :get, :edit, id: question.id, job_id: job.id  
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: question.id, job_id: job.id}
    end
    
    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @question to the correct question" do 
      expect(assigns(:question)).to eq(question)
    end
  end

  describe "PUT update" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:question) {Fabricate(:question, job_id: job.id, body: "Super Question")}
    let(:option) {Fabricate(:question_option, question_id: question.id)}
    let(:option2) {Fabricate(:question_option, question_id: question.id)}

    before do 
      set_current_user(alice)
      set_current_company(company)    
      job_board  
      job
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, body: "Screened"}, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, body: "Screened"}, job_id: job.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, body: "Screened"}, job_id: job.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: question.id, question: {job_id: job.id, body: "Screened"}, job_id: job.id}
    end

    context "with valid nested attributes for options" do 
      before do 
        xhr :put, :update, job_id: job.id, question: { kind: "checkbox", body: "Question 1", question_options_attributes: {"0" => { body: "Answer 1", _destroy: "false", id: option.id}, "1" => { body: "Answer 2", _destroy: "1", id: option2.id}}}, id: question.id
      end

      it "creates the question" do 
        expect(Question.count).to eq(1)
      end

      it "updates the question Option" do 
        expect(QuestionOption.first.body).to eq("Answer 1")
      end

      it "renders the create template" do
        expect(response).to render_template :update
      end
    end

    context "with valid inputs" do 
      before do 
        xhr :put, :update, id: question.id, question: {job_id: job.id, body: "Screened"}, job_id: job.id
      end
      it "save the updates made on the object" do 
        expect(Question.last.body).to eq("Screened")
      end

      it "renders the update template" do
        expect(response).to render_template :update
      end
    end

    context "with INVALID nested attributes for options" do 
      before do 
        xhr :put, :update, job_id: job.id, question: { kind: "checkbox", body: "Question 1", question_options_attributes: {"0" => { body: "", _destroy: "false", id: option.id}, "1" => { body: "Answer 2", _destroy: "1", id: option2.id}}}, id: question.id
      end

      it "does not update the question Option" do 
        expect(QuestionOption.first.body).to eq(option.body)
      end

      it "sets @errors instance variable" do
        expect(assigns(:errors)).to be_present
      end

      it "renders the update template" do
        expect(response).to render_template :update
      end
    end

    context "with INVALID inputs" do
      before do 
        xhr :put, :update, id: question.id, question: {job_id: job.id, body: nil}, job_id: job.id
      end
      it "save the updates made on the object" do 
        expect(Question.last.body).to eq("Super Question")
      end

      it "renders the update template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:bob) {Fabricate(:user, company: company, role: "Hiring Manager")} 
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:question) {Fabricate(:question, job_id: job.id, body: "Super Question")}

    before do 
      set_current_user(alice)
      set_current_company(company)    
      job_board  
      job
      question 
      @question2 = Fabricate(:question, job_id: job.id, body: "Super Question")
      xhr :delete, :destroy, job_id: job.id, id: question.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: question.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: question.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :delete, :destroy, job_id: job.id, id: question.id}
    end

    it "deletes the stage" do 
      expect(Question.count).to eq(1)
    end

    it "deletes the correct question" do 
      expect(job.questions.first).to eq(@question2)
    end

    it "renders the update template" do
      expect(response).to render_template :destroy
    end
  end
end