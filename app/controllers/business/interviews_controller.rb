class Business::InterviewsController < ApplicationController
  layout "business"
  
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  # include AuthHelper
  
  
  def job_interviews
    @job = Job.find(params[:job_id])
    @interviews = @job.interviews
  end

  def show 
    @interview = Interview.find(params[:id])
    @applicant = @interview.application.applicant
    @team = @interview.users 
  end
  
  def index
    @events = current_company.interviews

    respond_to do |format|
      format.js 
      format.json
      format.html
    end
  end

  def new
    @interview = Interview.new
    @candidates = current_company.candidates.order(:created_at).limit(10)
    @users = current_company.users.limit(10)

    respond_to do |format| 
      format.js 
    end 
  end

  def create
    @startTime = DateTime.parse(params[:interview][:date] + " " + params[:interview][:stime]).strftime("%Y-%m-%dT%H:%M:%S")
    @endTime = DateTime.parse(params[:interview][:date] + " " + params[:interview][:etime]).strftime("%Y-%m-%dT%H:%M:%S")
    @user_ids = params[:interview][:user_ids].split(',') 
    @interview = Interview.new(interview_params.merge!(user_ids: @user_ids, start_time: @startTime, end_time: @endTime))

    respond_to do |format|  
      if @interview.save
        @interviews = current_company.interviews
        send_invitation(@interview) if @interview.send_request == true
        format.js
      else        
        binding.pry
        render_errors(@interview)
        format.js
      end
    end
  end

  def edit 
    @interview = Interview.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @interview = Interview.find(params[:id])

    respond_to do |format|  
      if @interview.update(interview_params)
        @interviews = current_company.interviews
        format.js
      else
        render_errors(@interview)
        format.js
      end
    end
  end

  def destroy
    @interview = Interview.find(params[:id])
    @interview.destroy

    respond_to do |format| 
      format.js
    end
  end

  def search 
    where = {}
    
    if params[:query].present?
      query = params[:query] 
    else
      query = "*"
    end

    where[:type] = current_company.id 
    where[:rating] = params[:rating] if params[:rating].present?
    where[:job_title] = {all: params[:job_title]} if params[:job_title].present?
    where[:jobs] = {all: params[:jobs]} if params[:jobs].present?
    where[:job_status] = params[:status] if params[:status].present?
    where[:job_location] = params[:location] if params[:location].present?
    where[:tags] = {all: params[:tags]} if params[:tags].present?
    where[:created_at] = {gte: params[:date_applied].to_time, lte: Time.now} if params[:date_applied].present?

    if params[:qcv].present?
      @candidates = Candidate.search(params[:qcv], where: where, fields: qcv_fields, match: :word_start, per_page: 10, page: params[:page])
    else
      @candidates = Candidate.search(query, where: where, fields: fields, match: :word_start, per_page: 10, page: params[:page])
    end

    @events = Interview.search("*")
  end

  private

  def interview_params
    params.require(:interview).permit(:title, :notes, :location, :start_time, 
      :end_time, :kind, :send_request, :etime, :stime,
      :job_id, :candidate_id, :company_id, :date,
      user_ids: [])
  end

  def send_invitation(e)
    if e.users.first.google_token.present?
      GoogleWrapper::Calendar.create_event(current_user, e.start_time, e.end_time, 
        e.location, e.description, e.title, e.users, e.candidate)
    else  
      OutlookWrapper::Calendar.create_event_invite(e, e.users.first, e.start_time, e.end_time, e.candidate)
    end
  end

  def render_errors(interview)
    @errors = []
    interview.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end