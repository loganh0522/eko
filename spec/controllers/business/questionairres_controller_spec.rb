require 'spec_helper' 

describe Business::QuestionairresController do 
  describe "GET new" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}

    it_behaves_like "requires sign in" do
      let(:action) {get :new, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :new, job_id: job.id}
    end

    before do  
      set_current_user(alice)
      set_current_company(company)
      get :new, job_id: job.id
    end

    it "sets the @job to the current instance of the job" do 
      expect(assigns(:job)).to eq(job)
    end
    
    it "set @stage to be a new instance of Stages" do
      expect(assigns(:questionairre)).to be_new_record 
      expect(assigns(:questionairre)).to be_instance_of Questionairre
    end
  end

  describe "POST create" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:questionairre) {Fabricate(:questionairre, job_id: job.id)}
   
    
    it_behaves_like "requires sign in" do
      let(:action) {post :create, job_id: job.id}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {post :create, job_id: job.id}
    end

    before do 
      set_current_user(alice)
      set_current_company(company)

      post :create, questionairre: questionairre, job_id: job.id
    end

    it "creates the questionairre" do 
      expect(Questionairre.count).to eq(1)
    end

    it "associates the scorecard with the job" do 
      expect(Questionairre.first.job).to eq(job)
    end
  end

  describe "GET edit" do 
    let(:company) {Fabricate(:company)}
    let(:alice) {Fabricate(:user, company: company)}
    let(:job) {Fabricate(:job, company: company)}
    let(:questionairre) {Fabricate(:questionairre, job_id: job.id)}

    it_behaves_like "requires sign in" do
      let(:action) {get :edit, job_id: 2, id: 4}
    end

    it_behaves_like "user does not belong to company" do 
      let(:action) {get :edit, job_id: 2, id: 4}
    end
    
    before do      
      set_current_user(alice)
      set_current_company(company)   
      get :edit, id: questionairre.id, job_id: job.id  
    end

    it "sets @job to the correct job posting" do 
      expect(assigns(:job)).to eq(job)
    end

    it "sets @questionairre to the correct job posting" do 
      expect(assigns(:questionairre)).to eq(questionairre)
    end
  end
end