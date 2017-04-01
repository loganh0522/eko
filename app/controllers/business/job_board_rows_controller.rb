class Business::JobBoardRowsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new 
    @section = JobBoardRow.new
  end

  def create
    @section = JobBoardRow.new(job_board_row_params)
    @job_board = JobBoard.find(params[:job_board_id])
    respond_to do |format|
      if @section.save
        @sections = @job_board.job_board_rows
        format.js
      end
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def job_board_row_params
    params.require(:job_board_row).permit(:description, :job_board_id, :kind, 
      :layout, :video_link, :subheader, :header, :position, 
      media_photos_attributes: [:id, :file_name, :_destroy])
  end
end