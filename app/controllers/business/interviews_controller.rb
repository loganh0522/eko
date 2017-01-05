class Business::InterviewsController < ApplicationController
  
  def index

  end


  def create
    Interview.new(interview_params)

    if params[:user_id].present? 
      
    end
  end


  def edit 

  end

  private

  def interview_params
    params.require(:interview).permit(:notes, :location, :start_time, :end_time)
  end

end