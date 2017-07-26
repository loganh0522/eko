class Business::JobBoardsController < ApplicationController 
  filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company
  
  def show
    @job_board = JobBoard.find(params[:id])
    @section = JobBoardRow.new
    @job_board_header = @job_board.job_board_header
    @sections = @job_board.job_board_rows
  end

  def edit
    @job_board = JobBoard.find(params[:id])
    @section = JobBoardRow.new
    @job_board_header = @job_board.job_board_header
    @sections = @job_board.job_board_rows

    respond_to do |format|
      format.js 
    end
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
    params.require(:job_board).permit(:description, :logo, :subdomain, :header, :subheader, :cover_photo, 
      :brand_color, :text_color, :sub_header_color)
  end

end