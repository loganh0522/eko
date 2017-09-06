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
  
  def index
    @interviews = current_company.interviews

    # OutlookWrapper::Calendar.create_event(current_user, "2017-07-24T9:00pm", "2017-07-24T9:30pm")
    # @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @interviews_by_date = @interviews.group_by(&:start)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @interview = Interview.new

    respond_to do |format| 
      format.js 
    end 
  end

  def create
    @interview = Interview.new(interview_params)
    respond_to do |format|  
      if @interview.save
        format.js
      else

        format.js
      end
    end
  end

  def show 
    @interview = Interview.find(params[:id])
    @applicant = @interview.application.applicant
    @team = @interview.users 
  end


  def edit 

  end

  private

  def interview_params
    params.require(:interview).permit(:title, :notes, :location, :start_time, 
      :end_time, :date, :kind, :user_ids, 
      :job_id, :candidate_id, :company_id)
  end

end