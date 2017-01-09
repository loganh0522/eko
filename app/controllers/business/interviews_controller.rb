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

    if @interview.save 
      redirect_to :back
    else
      flash[:danger] = "Something went wrong"
    end
  end

  def show 
    @interview = Interview.find(params[:id])
    @applicant = @interview.application.applicant
  end


  def edit 

  end

  private

  def interview_params
    params.require(:interview).permit(:notes, :location, :start_time, :end_time, :date, :kind, :notes, :application_id)
  end

end