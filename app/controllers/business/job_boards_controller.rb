class Business::JobBoardsController < ApplicationController 
  def edit
    @job_board = JobBoard.find(params[:id])
  end

  def update
    @job_board = JobBoard.find(params[:id])

    if @job_board.update_attributes(job_params)
      flash[:success] = "You have successfully updated your Career Portal"
      redirect_to edit_business_job_board_path(@job_board)
    else
      flash[:error] = "Something went wrong. Please try again."
      render :edit 
    end
  end

  private 

  def job_params
    params.require(:job_board).permit(:description, :logo)
  end
end