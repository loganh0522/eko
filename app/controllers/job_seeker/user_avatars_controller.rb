class JobSeeker::UserAvatarsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete

  def new 
    @user_avatar = UserAvatar.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @avatar = UserAvatar.create(avatar_params)
    @user_avatar = current_user.user_avatar
    # @new_avatar = UserAvatar.new

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
    @avatar = UserAvatar.find(params[:id])

    if @avatar.update(avatar_params)
      @avatar.save!
      
      respond_to do |format|
        format.html {redirect_to job_seeker_user_path}
        format.js
      end
    else
      render_errors(@avatar)
    end
  end

  def destroy
    @user_avatar = UserAvatar.find(params[:id])
    @user_avatar.destroy

    respond_to do |format|
      format.js 
    end
  end

  private

  def avatar_params
    params.require(:user_avatar).permit(:image, :user_id, :crop_x, :crop_y, :crop_w, :crop_h)
  end
end