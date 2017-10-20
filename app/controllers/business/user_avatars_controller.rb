class Business::UserAvatarsController < ApplicationController
  layout "business"
  # filter_resource_access
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
    @avatar = UserAvatar.create(avatar_params)
    @user_avatar = current_user.user_avatar
    @new_avatar = UserAvatar.new
    
    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @user_avatar  = UserAvatar.find(params[:id])
    @new_avatar = UserAvatar.new
    respond_to do |format|
      format.js
    end
  end

  def update
    @user_avatar = UserAvatar.find(params[:id])
    @user_avatar.update(avatar_params)

    @user = @user_avatar.user
    respond_to do |format|
      format.js
    end
  end

  def destroy

  end

  private

  def avatar_params
    params.require(:user_avatar).permit(:image, :user_id, :crop_x, :crop_y, :crop_w, :crop_h)
  end
end