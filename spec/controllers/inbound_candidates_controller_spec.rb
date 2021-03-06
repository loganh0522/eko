require 'spec_helper'

describe InboundCandidatesController do 
  describe 'POST ziprecruiter_webhook' do
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:multichoice) {Fabricate(:question, job: job, kind: "Multiselect")}
    let(:singlechoice) {Fabricate(:question, job: job, kind: "Select (One)")}
    
    let(:question) {Fabricate(:question, job: job, kind: "Text (Long Answer)")}
    let(:option1) {Fabricate(:question_option, question_id: multichoice.id)}
    let(:option2) {Fabricate(:question_option, question_id: multichoice.id)}
    let(:option3) {Fabricate(:question_option, question_id: singlechoice.id)}
    let(:option4) {Fabricate(:question_option, question_id: singlechoice.id)}

    context 'with First name' do
      before do
        option4 

        post :ziprecruiter_webhook, {name: "logan houston", first_name: "logan", last_name: nil, job_id: job.id, 
        email: 'houston@talentwiz.ca', resume: Base64.encode64(open("./spec/fixtures/file.pdf").to_a.join), 
        answers: [{id: question.id, value: "yes"},
          {id: multichoice.id, values: [option1.id, option2.id]},
          {value: option3.id, id: singlechoice.id}]}
      end

      it "creates the application" do 
        expect(Application.count).to eq(1)
        expect(Candidate.count).to eq(1)
        expect(Candidate.first.resumes.count).to eq(1)
        expect(Candidate.last.full_name).to eq("Logan ")
      end

      it "creates the questionairre" do 
        expect(Questionairre.count).to eq(1)
        expect(Questionairre.first.questions.count).to eq(3)
        expect(Answer.count).to eq(4)
      end
    end

    context 'with only name' do
      before do
        option4

        post :ziprecruiter_webhook, {name: "logan houston", first_name: nil, last_name: nil, job_id: job.id, 
        email: 'houston@talentwiz.ca', resume: Base64.encode64(open("./spec/fixtures/file.pdf").to_a.join), 
        answers: [{id: question.id, value: "yes"}, 
          {id: multichoice.id, values: [option1.id, option2.id]}, 
          {value: option3.id, id: singlechoice.id}]}
      end

      it "creates the application" do 
        expect(Application.count).to eq(1)
        expect(Candidate.count).to eq(1)
        expect(Candidate.first.resumes.count).to eq(1)
        expect(Candidate.last.full_name).to eq("Logan houston")
      end

      it "creates the questionairre" do 
        expect(Questionairre.count).to eq(1)
        expect(Questionairre.first.questions.count).to eq(3)
        expect(Answer.count).to eq(4)
      end
    end

    context 'with First & last name' do
      before do
        option4

        post :ziprecruiter_webhook, {name: "logan houston", first_name: "logan", last_name: "houston", job_id: job.id, 
        email: 'houston@talentwiz.ca', resume: Base64.encode64(open("./spec/fixtures/file.pdf").to_a.join), 
        answers: [{id: question.id, value: "yes"}, 
          {id: multichoice.id, values: [option1.id, option2.id]}, 
          {value: option3.id, id: singlechoice.id}]}
      end

      it "creates the application" do 
        expect(Application.count).to eq(1)
        expect(Candidate.count).to eq(1)
        expect(Candidate.first.resumes.count).to eq(1)
        expect(Candidate.last.full_name).to eq("Logan houston")
      end

      it "creates the questionairre" do 
        expect(Questionairre.count).to eq(1)
        expect(Questionairre.first.questions.count).to eq(3)
        expect(Answer.count).to eq(4)
      end
    end
  end
end