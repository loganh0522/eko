class InboundCandidatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ziprecruiter_webhook]

  def ziprecruiter_webhook  
    @job = Job.find(params[:job_id])
    @company = @job.company

    @candidate = Candidate.create(company: @company, name: params[:name], first_name: params[:first_name], 
      last_name: params[:last_name], email: params[:email], phone: params[:phone], 
      manually_created: true, source: "ZipRecruiter")
    @application = Application.create(candidate_id: @candidate.id, job: @job)
    @encoded_resume = params[:resume]
    Resume.create(candidate_id: @candidate.id, name: "data:application/pdf;base64,#{@encoded_resume}")
    params[:answers].each do |answer| 
      @question = Question.find(answer[:id])
      if @question.kind == "Multiselect"
        answer.values.each do |value| 
          QuestionAnswer.create(question_id: answer[:id], question_option_id: value, 
            candidate_id: @candidate.id, job_id: @job.id, application_id: @application.id)
        end
      elsif @question.kind == "Select (One)"
        QuestionAnswer.create(question_id: answer[:id], question_option_id: answer[:value], 
          candidate_id: @candidate.id, job_id: @job.id, application_id: @application.id)
      elsif @question.kind == "File"
        @encoded_answer = answer[:value]
        QuestionAnswer.create(question_id: answer[:id], 
          file: "data:application/pdf;base64,#{@encoded_answer}", 
          job_id: @job.id, candidate_id: @candidate.id, application_id: @application.id)
      else
        QuestionAnswer.create(question_id: answer[:id], body: answer[:value], 
          job_id: @job.id, candidate_id: @candidate.id, application_id: @application.id)
      end
    end

    head 200
  end

  def indeed_webhook  
    @job = Job.find(params[:job][:jobId])
    @company = @job.company

    @candidate = Candidate.create(company: @company, name: params[:applicant][:fullName], 
      first_name: params[:applicant][:first_name], 
      last_name: params[:applicant][:last_name], 
      email: params[:applicant][:email], 
      phone: params[:applicant][:phoneNumber], 
      manually_created: true, source: "Indeed")

    @application = Application.create(candidate_id: @candidate.id, job: @job)
    
    @encoded_resume = params[:applicant][:resume][:file][:data]
    
    Resume.create(candidate_id: @candidate.id, name: "data:application/pdf;base64,#{@encoded_resume}")
    
    if params[:applicant][:resume][:json].present?
      create_indeed_candidate(@candidate)
    end

    if params[:questions][:answers].present?
      create_answers
    end
    head 200
  end

  private

  def create_answers
    params[:questions][:answers].each do |answer| 
      @question = Question.find(answer[:id])
      
      if @question.kind == "Multiselect"
        answer.values.each do |value| 
          QuestionAnswer.create(question_id: answer[:id], question_option_id: value, 
            candidate_id: @candidate.id, job_id: @job.id, application_id: @application.id)
        end
      elsif @question.kind == "Select (One)"
        QuestionAnswer.create(question_id: answer[:id], question_option_id: answer[:value], 
          candidate_id: @candidate.id, job_id: @job.id, application_id: @application.id)
      elsif @question.kind == "File"
        @encoded_answer = answer[:value]
        QuestionAnswer.create(question_id: answer[:id], 
          file: "data:application/pdf;base64,#{@encoded_answer}", 
          job_id: @job.id, candidate_id: @candidate.id, application_id: @application.id)
      else
        QuestionAnswer.create(question_id: answer[:id], body: answer[:value], 
          job_id: @job.id, candidate_id: @candidate.id, application_id: @application.id)
      end
    end
  end
  
  def create_indeed_candidate(candidate)
    indeed_create_positions(candidate)
    indeed_create_educations(candidate)
    indeed_create_links(candidate)
    indeed_create_awards(candidate)
    # indeed_create_certifications(candidate)
    indeed_create_associations(candidate)
    indeed_create_patents(candidate)
    indeed_create_military_services(candidate)
  end

  def indeed_create_positions(candidate)
    params[:applicant][:resume][:json][:positions][:values].each do |e|
      WorkExperience.create(candidate: candidate, title: e[:title], company_name: e[:company],
        start_month: e[:startDateMonth], start_year: e[:startDateYear], 
        description: e[:description])
    end
  end

  def indeed_create_educations(candidate)
    params[:applicant][:resume][:json][:educations][:values].each do |e|
      Education.create(candidate: candidate, school: e[:school], 
        degree: e[:degree], field: e[:field], 
        start_year: e[:startDate], end_year: e[:endDate])
    end
  end

  def indeed_create_links(candidate)
    params[:applicant][:resume][:json][:links][:values].each do |e|
      SocialLink.create(candidate: candidate, url: e[:url])
    end
  end

  def indeed_create_awards(candidate)
    params[:applicant][:resume][:json][:awards][:values].each do |e|
      Award.create(candidate: candidate, title: e[:title], 
        date_month: e[:dateMonth], date_year: e[:dateYear],
        description: e[:description])
    end
  end

  def indeed_create_certifications(candidate)
    params[:applicant][:resume][:json][:certifications][:values].each do |e|

      Certification.create(candidate: candidate, name: e[:title], 
        description: e[:description],
        start_month: e[:startDateMonth], start_year: e[:startDateYear],
        end_month: e[:endDateMonth], end_year: e[:endDateYear])
    end
  end

  def indeed_create_associations(candidate)
    params[:applicant][:resume][:json][:associations][:values].each do |e|
      CandidateAssociation.create(candidate: candidate, title: e[:title], 
        description: e[:description], current: e[:endCurrent],
        start_month: e[:startDateMonth], start_year: e[:startDateYear],
        end_month: e[:endDateMonth], end_year: e[:endDateYear]
        )
    end
  end

  def indeed_create_patents(candidate)
    params[:applicant][:resume][:json][:patents][:values].each do |e|
      Patent.create(candidate: candidate, title: e[:title], 
        description: e[:description], url: e[:url],
        patent_number: e[:patent_number],
        date_month: e[:startDateMonth], date_year: e[:startDateYear]
        )
    end
  end

  def indeed_create_publications(candidate)
    params[:applicant][:resume][:json][:publications][:values].each do |e|
      Publications.create(candidate: candidate, title: e[:title], 
        description: e[:description], url: e[:url],
        date_month: e[:startDateMonth], date_year: e[:startDateYear]
        )
    end
  end

  def indeed_create_military_services(candidate)
    params[:applicant][:resume][:json][:militaryServices][:values].each do |e|
      MilitaryService.create(candidate: candidate, branch: e[:branch], 
        rank: e[:rank], service_country: e[:serviceCountry],
        commendations: e[:commendations], 
        description: e[:description], current: e[:endCurrent],
        start_month: e[:startDateMonth], start_year: e[:startDateYear],
        end_month: e[:endDateMonth], end_year: e[:endDateYear]
        )
    end
  end
end
