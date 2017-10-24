class Business::BackgroundImagesController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index

  end

  def new 
    @background = BackgroundImage.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @background = BackgroundImage.create(logo_params)
    @job_board_header = @background.job_board_header if @background.job_board_header_id.present?
    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @background = BackgroundImage.find(params[:id])


    respond_to do |format|
      format.js
    end
  end

  def update
    @background = BackgroundImage.find(params[:id])
    @background.update(logo_params)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @background = BackgroundImage.find(params[:id])
    @background.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def logo_params
    params.require(:background_image).permit(:file, :company_id, :job_board_row_id, :job_board_header_id)
  end
end