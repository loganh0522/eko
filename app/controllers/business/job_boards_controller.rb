class Business::JobBoardsController < ApplicationController 
  layout "business"
  
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company
  
  def show
    @job_board = JobBoard.find(params[:id])
    @job_board_header = @job_board.job_board_header
    @sections = @job_board.job_board_rows

    if @job_board_header.background_image.present?
      @background = @job_board_header.background_image
    else
      @background = BackgroundImage.new 
    end

    if current_company.logo.present?
      @logo = current_company.logo
    else
      @logo = Logo.new
    end
  end

  def edit
    @job_board = JobBoard.find(params[:id])
    @sections = @job_board.job_board_rows

    respond_to do |format|
      format.js 
    end
  end

  def update
    @job_board = JobBoard.find(params[:id])

    if params[:kind].present? 
      @job_board.update_attributes(kind: params[:kind])
    end

    respond_to do |format| 
      if @job_board.update_attributes(job_params)
        format.js
      end
    end
  end

  private 

  def job_params
    params.require(:job_board).permit(:description, :logo, :subdomain, :header, :subheader, :cover_photo, 
      :brand_color, :text_color, :sub_header_color,
      header_links_attributes: [:id, :name, :job_board_row_id, :_destroy])
  end

end