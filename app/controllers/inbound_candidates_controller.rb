class InboundCandidatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ziprecruiter_webhook]

  def ziprecruiter_webhook  
    @job = Job.find(params[:job_id])
    @company = @job.company

    @candidate = Candidate.create(company: @company, name: params[:name], first_name: params[:first_name], 
      last_name: params[:last_name], email: params[:email], phone: params[:phone], 
      manually_created: false, source: "ZipRecruiter")
    
    @application = Application.create(candidate: @candidate, job: @job)
    
    @encoded_resume = params[:resume]
    Resume.create(candidate_id: @candidate.id, name: "data:application/pdf;base64,#{@encoded_resume}")

    
    params[:answers].each do |answer| 
      @question = Question.find(answer[:id])

      if @question.kind == "Multiselect"
        answer.values.each do |value| 
          QuestionAnswer.create(question_id: answer[:id], question_option_id: value)
        end
      elsif @question.kind == "Select (One)"
        QuestionAnswer.create(question_id: answer[:id], question_option_id: answer[:value])
      elsif @question.kind == "File"
        @encoded_answer = answer[:value]
        QuestionAnswer.create(question_id: answer[:id], file: "data:application/pdf;base64,#{@encoded_answer}", 
          job_id: @job.id, candidate_id: @candidate.id)
      else
        QuestionAnswer.create(question_id: answer[:id], body: answer[:value], 
          job_id: @job.id, candidate_id: @candidate.id)
      end
    end

    head 200
  end

  def indeed_webhook  
    details = JSON.parse params.first.first
    @job = Job.find(details["job_id"])
    @company = @job.company

    @candidate = Candidate.create(company: @company, first_name: details["first_name"], last_name: details["last_name"],
      email: details["email"], email: details["phone"], manually_created: false)
    @application = Application.create(candidate: @candidate, job: @job)


    # Resume.create(candidate: @candidate, name: details)
  end

end

# {"response_id": "a39bd9a", "job_id": "1000002", "name": "Tom Foolery", "first_name": "Tom", "last_name": "Foolery", "email": "tf@example.org", 
# "phone": "555 5551942", "resume": "JVBERi0xLjUKJb/3ov4KMiAwIG9iago8PCAvTGluZWFyaXplZCAxIC9MIDE3ODA3IC9IIFsgNjg3IDEyNiBdIC9PIDYgL0UgMTc1MzIgL04gMSAvVCAjIxNgolJUVPRgo="}


