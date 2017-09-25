class Business::JobBoardHeadersController < ApplicationController 
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?


  def create

  end

  def edit 
    respond_to do |format|
      @job_board_header = JobBoardHeader.find(params[:id])
      @job_board = JobBoard.find(params[:job_board_id])
      format.js
    end
  end

  def update
    @job_board_header = JobBoardHeader.find(params[:id])
    @job_board = JobBoard.find(params[:job_board_id])
    
    respond_to do |format|
      if @job_board_header.update(job_board_header_params)
        @job_board_header = @job_board.job_board_header
        format.js
      end
    end
  end

  private

  def job_board_header_params
    params.require(:job_board_header).permit(:header, :subheader, :logo, :cover_photo, :job_board_id)
  end
end