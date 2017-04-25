class JobSeeker::UserAvatarsController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete
  

  def new 
    @user_avatar = UserAvatar.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @avatar = UserAvatar.create(avatar_params)

    @user_avatar = current_user.user_avatar
    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @user_avatar  = UserAvatar.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @user_avatar = UserAvatar.find(params[:id])
    @user_avatar.update(avatar_params)

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