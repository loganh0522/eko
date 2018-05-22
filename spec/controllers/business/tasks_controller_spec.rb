require 'spec_helper' 

describe Business::TasksController do 
  let(:company) {Fabricate(:company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:job) {Fabricate(:job, company: company)}
  let(:candidate) {Fabricate(:candidate, company: company)}
  let(:application) {Fabricate(:application, candidate: candidate, job: job)}
  let(:client){Fabricate(:client, company: company)}
  let(:task) {Fabricate(:task, taskable_type: "Company", taskable_id: company.id, company: company)}
  let(:job_task) {Fabricate(:task, taskable_type: "Job", taskable_id: job.id, company: company, job_id: job.id)}
  let(:candidate_task) {Fabricate(:task, taskable_type: "Candidate", taskable_id: candidate.id, company: company)}
  let(:client_task) {Fabricate(:task, taskable_type: "Client", taskable_id: client.id, company: company)}
  let(:application_task) {Fabricate(:task, taskable_type: "Candidate", taskable_id: candidate.id, company_id:company.id, job_id: job.id)}
  
  before do  
    set_current_user(alice)
    set_current_company(company)
    job_board
    job
    candidate
    task
    candidate_task
    job_task
    client_task
    application_task
  end

  describe "GET job_tasks" do 
    context "@job in params renders job.comments" do 
      before do  
        get :job_tasks, job_id: job.id
      end

      it "sets the @tasks to the current Job" do 
        expect(job.open_tasks.count).to eq(2)
        expect(job.tasks.first.title).to eq(job_task.title)
        expect(assigns[:tasks]).to eq([job_task, application_task])
      end
    end
  end

  describe "GET client_tasks" do 
    context "@job in params renders job.comments" do 
      before do  
        xhr :get, :job_tasks, job_id: job.id
      end
      
      it "sets the @tasks to the current Job" do 
        expect(job.open_tasks.count).to eq(2)
        expect(job.tasks.first.title).to eq(job_task.title)
        expect(assigns[:tasks]).to eq([job_task, application_task])
      end
    end
  end

  describe "GET index" do 
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :index}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {get :index}
    end

    it_behaves_like "trial is over" do 
      let(:action) {get :index}
    end

    context "main index of tasks page" do 
      before do  
        get :index
      end

      it "sets @tasks to the open tasks for current_company" do 
        expect(company.tasks.count).to eq(5)
      end
    end

    # context "get APPLICATION tasks" do 
    #   before do  
    #     xhr :get, :index, job: job.id, candidate_id: candidate.id
    #   end 

    #   it "sets the @tasks to the current Candidate" do 
    #     expect(assigns[:tasks]).to eq([application_task])
    #     expect(assigns[:tasks].count).to eq(1)
    #   end

    #   it "expects the response to render index template" do
    #     expect(response).to render_template :index
    #   end
    # end

    # context "get CANDIDATE tasks" do 
    #   before do  
    #     xhr :get, :index, candidate_id: candidate.id
    #   end 

    #   it "sets the @tasks to the current Candidate" do 
    #     expect(assigns[:tasks]).to eq([application_task, candidate_task])
    #     expect(assigns[:tasks].count).to eq(2)
    #     expect(candidate.open_tasks.first).to eq(application_task)
    #   end

    #   it "expects the response to render index template" do
    #     expect(response).to render_template :index
    #   end
    # end
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


    context "adding a task from index page" do 
      before do 
        xhr :get, :new
      end

      it "sets @task to be a new instance of Task" do 
        expect(assigns(:task)).to be_new_record 
        expect(assigns(:task)).to be_instance_of Task
      end

      it "sets @taskable to an instance of current company" do 
        expect(assigns(:taskable)).to eq(company)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "adding a new JOB task" do 
      before do 
        xhr :get, :new, job_id: job.id
      end

      it "sets @task to be a new instance of Task" do 
        expect(assigns(:task)).to be_new_record 
        expect(assigns(:task)).to be_instance_of Task
      end

      it "sets @taskable to an instance of current company" do 
        expect(assigns(:taskable)).to eq(job)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "adding a new APPLICATION task" do 
      before do 
        xhr :get, :new, job: job.id, candidate_id: candidate.id
      end

      it "sets @task to be a new instance of Task" do 
        expect(assigns(:task)).to be_new_record 
        expect(assigns(:task)).to be_instance_of Task
      end

      it "sets @taskable to an instance of current company" do 
        expect(assigns(:taskable)).to eq(candidate)
      end

      it "sets @job to an instance of current company" do 
        expect(assigns(:job)).to eq(job)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "adding a new CANDIDATE task" do 
      before do 
        xhr :get, :new, candidate_id: candidate.id
      end

      it "sets @task to be a new instance of Task" do 
        expect(assigns(:task)).to be_new_record 
        expect(assigns(:task)).to be_instance_of Task
      end

      it "sets @taskable to an instance of current company" do 
        expect(assigns(:taskable)).to eq(candidate)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end

    context "adding a new CLIENT task" do 
      before do 
        xhr :get, :new, client_id: client.id
      end

      it "sets @task to be a new instance of Task" do 
        expect(assigns(:task)).to be_new_record 
        expect(assigns(:task)).to be_instance_of Task
      end

      it "sets @taskable to an instance of current company" do 
        expect(assigns(:taskable)).to eq(client)
      end

      it "expects the response to render new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do  
    it_behaves_like "requires sign in" do
      let(:action) {xhr :post, :create, task: Fabricate.attributes_for(:task)}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :post, :create, task: Fabricate.attributes_for(:task)}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :post, :create, task: Fabricate.attributes_for(:task)}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :post, :create, task: Fabricate.attributes_for(:task)}
    end

    context "creates COMPANY task" do
      before do  
        xhr :post, :create, task: Fabricate.attributes_for(:task, taskable_type: "Company", taskable_id: company.id, company: company, user_ids: alice.id, candidate_ids: '')
      end
      
      it "creates the task" do
        expect(Task.count).to eq(6)
      end

      it "associates the task to the correct records" do
        expect(Task.last.company).to eq(company)
        expect(company.tasks.count).to eq(6)
        expect(assigns[:tasks].count).to eq(6)
      end

      it "creates an activity related to the task" do 
        expect(Activity.count).to eq(6)
        expect(Task.last.activity).to be_present
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "creates a JOB task" do
      before do  
        xhr :post, :create, job_id: job.id, task: Fabricate.attributes_for(:task, taskable_type: "Job", taskable_id: job.id, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id, job_id: job.id)
      end
      
      it "creates the task" do
        expect(Task.count).to eq(6)
      end

      it "associates the task to the correct records" do
        expect(Task.last.job).to eq(job)
        expect(job.open_tasks.count).to eq(3)
      end

      it "assigns tasks to the correct tasks for application" do 
        expect(assigns[:tasks]).to eq([job_task, application_task, Task.last] )
        expect(assigns[:tasks].count).to eq(3)
      end

      it "renders the create action" do 
        expect(response).to render_template :create
      end
    end

    context "creates a CANDIDATE task" do
      before do  
        xhr :post, :create, candidate_id: candidate.id, task: Fabricate.attributes_for(:task, taskable_type: "Candidate", taskable_id: candidate.id, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id)
      end
      
      it "creates the task" do
        expect(Task.count).to eq(6)
      end

      it "associates the task to the correct records" do
        expect(Task.last.taskable).to eq(candidate)
        expect(candidate.tasks.count).to eq(3)
      end

      it "assigns tasks to the correct tasks for application" do 
        expect(assigns[:tasks].count).to eq(3)
        expect(assigns[:tasks]).to eq([Task.last, application_task, candidate_task])
      end

      it "creates an activity related to the task" do 
        expect(Activity.count).to eq(6)
        expect(Task.last.activity).to be_present
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    context "creates an APPLICATION task" do
      before do  
        xhr :post, :create, candidate_id: candidate.id, task: Fabricate.attributes_for(:task, taskable_type: "Candidate", taskable_id: candidate.id, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id, job_id: job.id)
      end
      
      it "creates the task" do
        expect(Task.count).to eq(6)
      end

      it "associates the task to the correct records" do
        expect(Task.last.taskable).to eq(candidate)
        expect(Task.last.job_id).to eq(job.id)
      end

      it "creates an activity related to the task" do 
        expect(Activity.count).to eq(6)
        expect(Task.last.activity).to be_present
      end

      it "assigns tasks to the correct tasks for application" do 
        expect(assigns[:tasks]).to eq([Task.last, application_task])
        expect(assigns[:tasks].count).to eq(2)
      end

      it "renders the new action" do 
        expect(response).to render_template :create
      end
    end

    # context "creates an CLIENT task" do
    #   before do  
    #     xhr :post, :create, task: Fabricate.attributes_for(:task, taskable_type: "Candidate", taskable_id: candidate.id, company: company, job_id: job.id), user_id: alice.id
    #   end
      
    #   it "creates the task" do
    #     expect(Task.count).to eq(6)
    #   end

    #   it "associates the task to the correct records" do
    #     expect(Task.last.taskable).to eq(client)
    #   end

    #   it "assigns tasks to the correct tasks for application" do 
    #     expect(assigns[:tasks]).to eq([Task.last, client_task])
    #     expect(assigns[:tasks].count).to eq(2)
    #   end

    #   it "renders the new action" do 
    #     expect(response).to render_template :create
    #   end
    # end
  end
  
  describe "GET edit" do     
    it_behaves_like "requires sign in" do
      let(:action) {xhr :get, :edit, id: task.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :get, :edit, id: task.id }
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :get, :edit, id: task.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :get, :edit, id: task.id}
    end
    
    context "@task belongs to the company through taskable" do 
      before do  
        xhr :get, :edit, id: task.id
      end
      
      it "sets @task to the correct task" do 
        expect(assigns(:task)).to eq(task)
      end

      it "sets @taskable to the correct parent" do
        expect(assigns(:taskable)).to eq(company)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PUT update" do 
    it_behaves_like "requires sign in" do
      let(:action) {xhr :put, :update, id: task.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {xhr :put, :update, id: task.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) {xhr :put, :update, id: task.id}
    end

    it_behaves_like "trial is over" do 
      let(:action) {xhr :put, :update, id: task.id}
    end

    context "with valid inputs" do
      before do 
        xhr :put, :update, id: task.id, task: {title: "Thomas Johnson"}
      end

      it "updates the task" do 
        expect(Task.first.title).to eq("Thomas Johnson")
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid inputs" do
      before do 
        xhr :put, :update, id: task.id, task: {title: nil}
      end

      it "sets the @email_signature to the current_user" do 
        expect(Task.first.title).to eq(task.title)
      end

      it "expects the response to render edit template" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE destroy" do 
    before do  
      xhr :delete, :destroy, id: task.id
    end

    it_behaves_like "requires sign in" do
      let(:action) {xhr :delete, :destroy, id: task.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) { xhr :delete, :destroy, id: task.id}
    end

    it_behaves_like "company has been deactivated" do
      let(:action) { xhr :delete, :destroy, id: task.id}
    end

    it "destroys the correct instance of the candidate" do 
      expect(Task.count).to eq(4)
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
      xhr :post, :create_multiple, task: Fabricate.attributes_for(:task, company_id: company.id, user_ids: alice.id, candidate_ids: "", user_id: alice.id, job_id: job.id), applicant_ids: "#{@candidate1.id}, #{@candidate2.id}, #{@candidate3.id}"
    end

    it "creates the task" do
      expect(Task.count).to eq(8)
    end

    it "associates the task to the correct records" do
      expect(@candidate1.tasks.count).to eq(1)
      expect(@candidate2.tasks.count).to eq(1)
      expect(@candidate3.tasks.count).to eq(1)
    end

    it "renders the new action" do 
      expect(response).to render_template :create_multiple
    end
  end

  describe "POST completed" do 
    before do 
      xhr :post, :completed, id: task.id
    end

    it "destroys the correct instance of the candidate" do 
      expect(Task.first.status).to eq('complete')
      expect(Task.first.completed_by_id).to eq(alice.id)
    end

    it "renders the complete template" do 
      expect(response).to render_template :completed
    end
  end
end