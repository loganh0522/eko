class Business::JobBoardsController < ApplicationController 
  def edit
    @job_board = JobBoard.find(params[:id])
  end

  def update
    @job_board = JobBoard.find(params[:id])

    if @job_board.update(job_params)
      flash[:success] = "You have successfully updated your Career Portal"
      redirect_to edit_business_job_board_path(@job_board)
    else
      flash[:error] = "Something went wrong. Please try again."
      render :edit 
    end
  end

end