class InboundCandidatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ziprecruiter_webhook]


  def ziprecruiter_webhook  
    details = JSON.parse params.first.first
    @job = Job.find(details["job_id"])
    @company = @job.company

    @candidate = Candidate.create(company: @company, first_name: details["first_name"], last_name: details["last_name"],
      email: details["email"], email: details["phone"], manually_created: true)
    @application = Application.create(candidate: @candidate, job: @job)


    # Resume.create(candidate: @candidate, name: details)
  end

end

{"response_id": "a39bd9a", "job_id": "1000002", "name": "Tom Foolery", "first_name": "Tom", "last_name": "Foolery", "email": "tf@example.org", "phone": "555 5551942", "resume": "JVBERi0xLjUKJb/3ov4KMiAwIG9iago8PCAvTGluZWFyaXplZCAxIC9MIDE3ODA3IC9IIFsgNjg3IDEyNiBdIC9PIDYgL0UgMTc1MzIgL04gMSAvVCAjIxNgolJUVPRgo="}