class JobSeeker::BackgroundImagesController < ApplicationController
  layout "job_seeker"
  before_filter :require_user

  def new 
    @background = BackgroundImage.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @background = BackgroundImage.create(background_params)
    @social_links = current_user.social_links

    if current_user.user_avatar.present?
      @avatar = current_user.user_avatar 
    else 
      @avatar = UserAvatar.new
    end
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
    @background.update(background_params)
    @social_links = current_user.social_links

    if current_user.user_avatar.present?
      @avatar = current_user.user_avatar 
    else 
      @avatar = UserAvatar.new
    end
    
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

  def background_params
    params.require(:background_image).permit(:file, :user_id)
  end
end