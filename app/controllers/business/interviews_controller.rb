class Business::InterviewsController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    # @interviews = current_company.interviews.all
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @interviews_by_date = @interviews.group_by(&:interview_date)
    @interviews = current_user.interviews
    
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