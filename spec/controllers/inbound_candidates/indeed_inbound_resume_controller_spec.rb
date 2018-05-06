require 'spec_helper'


describe InboundCandidatesController do

  describe "creates a Candidate & an Application" do 
    let(:company) {Fabricate(:company)}
    let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
    let(:alice) {Fabricate(:user, company: company, role: "Admin")}
    let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
    let(:multichoice) {Fabricate(:question, kind: "Multiselect")}
    let(:singlechoice) {Fabricate(:question, kind: "Select (One)")}
    let(:question) {Fabricate(:question, job_id: job.id, kind: "Text (Long Answer)")}
    let(:option1) {Fabricate(:question_option, question_id: multichoice.id)}
    let(:option2) {Fabricate(:question_option, question_id: multichoice.id)}
    let(:option3) {Fabricate(:question_option, question_id: singlechoice.id)}
    let(:option4) {Fabricate(:question_option, question_id: singlechoice.id)}

    let(:event_data) do
      {  
        "applicant" => {  
          "email" => "john.doe@indeed.com",
          "fullName" => "Logan Houston",
          "phoneNumber" => "555-555-4321",
          "resume":{  
            "file":{  
              "contentType" => "text/plain",
              "data" => Base64.encode64(open("./spec/fixtures/file.pdf").to_a.join),
              "fileName" => "resume.txt"
            }
          }
        },
        "appliedOnMillis" => 1325276227653,
        "locale" => "en_US",
        "job":{  
          "jobCompany" => company.name,
          "jobId" => job.id,
          "jobLocation" => "New York, NY 10110",
          "jobMeta" => "",
          "jobTitle" => "Test Engineer",
          "jobUrl" => "http://www.yourcompany.com/careers/yourjob123.html"
        },
        "questions" => {
          "answers" => [
            {
              "id" => question,
              "value" => "2600 Esperanza Crossing"
            },
            {
              "id" => singlechoice,
              "value" => option3
            },
            {
              "id" => multichoice,
              "values" => [
                option1,
                option2
              ]
            },
            # {
            #   "id" => file,
            #   "values" => [

            #   ]
            # },
          ]
        },
      }
    end


    before do 
      post :indeed_webhook, event_data
    end

    it "creates the application" do 
      expect(Application.count).to eq(1)
      expect(Candidate.count).to eq(1)
      expect(Resume.count).to eq(1)
      expect(Candidate.first.resumes.count).to eq(1)
      expect(Candidate.last.full_name).to eq("Logan houston")
    end

    it "creates the answers" do 
      expect(Candidate.last.question_answers.count).to eq(4)
    end
  end
end