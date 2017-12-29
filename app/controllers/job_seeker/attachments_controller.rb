class JobSeeker::AttachmentsController < ApplicationController 
  layout "job_seeker"
  before_filter :require_user
  
  def index

  end

  def new 
    @attachement = Attachment.new

    respond_to do |format| 
      format.js
    end
  end

  def create   

    if params[:file].present?
      @attachment = Attachment.create(user_id: current_user.id, file: params[:file], 
        file_type: params[:file].content_type, title: params[:file].original_filename)
    else
      @attachment = Attachment.create(user_id: current_user.id, link: params[:link], file_type: 'Link')
    end

    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @attachment = Attachment.find(params[:id])
    @attachment.update(attachment_params)
    
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.js
    end
  end

  private
  

  def attachment_params
    params.require(:media_photo).permit(:user_id, :project_id, :file, :link, :title, :description)
  end
end