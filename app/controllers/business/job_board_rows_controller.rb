class Business::JobBoardRowsController < ApplicationController 
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new 
    @section = JobBoardRow.new
    @job_board = JobBoard.find(params[:job_board_id])
    @section_type = params[:kind]
    respond_to do |format|
      format.js
    end
  end

  def create   
    if params[:job_board_row][:video_link].present? 
      video_parse_function
      @section = JobBoardRow.new(job_board_row_params.merge!(youtube_id: @video_id ))
    else
      @section = JobBoardRow.new(job_board_row_params)  
    end

    @job_board = JobBoard.find(params[:job_board_id])
    respond_to do |format|
      if @section.save
        @sections = @job_board.job_board_rows
        format.js
      end
    end
  end

  def edit 
    respond_to do |format|
      @job_board = JobBoard.find(params[:job_board_id])
      @section = JobBoardRow.find(params[:id])
      @job_board_header = @job_board.job_board_header
      @section_type = @section.kind
      format.js
    end
  end

  def update
    @section = JobBoardRow.find(params[:id])
    @job_board = JobBoard.find(params[:job_board_id])
    @job_board_header = @job_board.job_board_header
    respond_to do |format|
      if @section.update(job_board_row_params)
        @sections = @job_board.job_board_rows
        format.js
      end
    end
  end

  def destroy

  end

  private

  def video_parse_function
    regex = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
    link = params[:job_board_row][:video_link]
    @video_id = link.match(regex)[7]
  end

  def job_board_row_params
    params.require(:job_board_row).permit(:description, :job_board_id, :kind, 
      :layout, :video_link, :subheader, :header, :position, 
      media_photos_attributes: [:id, :file_name, :_destroy])
  end
end