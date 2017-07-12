class Business::InterviewsController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  include AuthHelper
  
  def index
    get_access_token
    # token = current_user.outlook_token.access_token
    # email = current_user.email
    # # @interviews = current_company.interviews.all

    # @interviews = OutlookWrapper::Calendar.get_events(token, email)

    # @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @interviews_by_date = @interviews.group_by(&:start)


    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @candidate = Candidate.find(params[:candidate_id])
    @application = Application.find(params[:application])
    @interview = Interview.new

    respond_to do |format| 
      format.js 
    end 
  end

  def create
    @interview = Interview.new(interview_params)
    respond_to do |format|  
      if @interview.save
        assigned_to(@interview)
        format.js
      else
        flash[:danger] = "Something went wrong"
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

  def assigned_to(task)
    user_ids = params[:interview][:user_ids].split(',')
    user_ids.each do |id| 
      AssignedUser.create(assignable_type: "Interview", assignable_id: task.id, user_id: id )
    end
  end

  def interview_params
    params.require(:interview).permit(:title, :notes, :location, :start_time, :end_time, :date, :kind, :job_id, :candidate_id, :company_id)
  end

end