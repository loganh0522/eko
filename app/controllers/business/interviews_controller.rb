class Business::InterviewsController < ApplicationController
  layout "business"
  # filter_access_to :all
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
    @interviews = current_company.interviews
    @events = []
    @room = Room.find(5)
    @users = [current_user, @room]

    @users.each do |user|
      @e = OutlookWrapper::Calendar.get_events(user)
      @e.each do |event| 
        @events.push(event)
      end
    end

    binding.pry
    # OutlookWrapper::Calendar.create_event(current_user, "2017-07-24T9:00pm", "2017-07-24T9:30pm")
    # @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @interviews_by_date = @interviews.group_by(&:start)
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

    @startTime = DateTime.parse(params[:date] + " " + params[:interview][:stime]).strftime("%Y-%m-%dT%H:%M:%S")
    @endTime = DateTime.parse(params[:date] + " " + params[:interview][:etime]).strftime("%Y-%m-%dT%H:%M:%S")
    @user_ids = params[:interview][:user_ids].split(',') 
    @interview = Interview.new(interview_params.merge!(user_ids: @user_ids, start_time: @startTime, end_time: @endTime))


    respond_to do |format|  
      if @interview.save
        binding.pry
        @interviews = current_company.interviews
        format.js
      else
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

  end

  private

  def interview_params
    params.require(:interview).permit(:title, :notes, :location, :start_time, 
      :end_time, :kind, :send_request, :etime, :stime,
      :job_id, :candidate_id, :company_id,
      user_ids: [])
  end

  def send_invitation(e)
    if e.user.first.google_token.present?
      GoogleWrapper::Calendar.create_event(current_user, e.start_time, e.end_time, 
        e.location, e.description, e.title, e.users, e.candidate)
    else  
      OutlookWrapper::Calendar.create_event_invite(e.users.first, e.start_time, e.end_time, e.candidate)
    end
  end




  def render_errors(interview)
    @errors = []
    interview.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end