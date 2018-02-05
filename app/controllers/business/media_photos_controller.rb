class Business::MediaPhotosController < ApplicationController
  layout "business"
  
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index

  end

  def new 
    @user_avatar = UserAvatar.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @photo = MediaPhoto.create(photo_params)

    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @photo  = MediaPhoto.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @photo = MediaPhoto.find(params[:id])
    @photo.update(photo_params)
    
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @photo = MediaPhoto.find(params[:id])
    @photo.destroy
  end

  private

  def photo_params
    params.require(:media_photo).permit(:file_name)
  end
end