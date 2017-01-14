class Business::InterviewsController < ApplicationController
  
  def index

  end

  def new
    @application = Application.find()
    @interview = Interview.new
    respond_to do |format| 
      format.js 
    end 
  end

  def create
    @interview = Interview.new(interview_params)
    @team = params[:user_ids].split(',')

    if @interview.save 
      @team.each do |user| 
        @user = user.to_i
        MyInterview.create(user_id: @user, interview_id: @interview.id)
      end
      redirect_to :back
    else
      flash[:danger] = "Something went wrong"
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
    params.require(:interview).permit(:notes, :location, :start_time, :end_time, :interview_date, :kind, :notes, :application_id, :job_id, :company_id)
  end

end