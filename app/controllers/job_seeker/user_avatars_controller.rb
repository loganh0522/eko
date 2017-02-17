class JobSeeker::UserAvatarsController < JobSeekersController
  before_filter :require_user
  
  require 'RMagick'

  def new 

  end

  def create
    @user_avatar = UserAvatar.new(user_params)
    @user_avatar.user = current_user

    
    if @user_avatar.save 
      redirect_to job_seeker_profiles_path
    end
  end

  def crop
    respond_to do |format|
      if @sample.save
        format.js
      end
    end
  end

  def update
    binding.pry
    @user_avatar = UserAvatar.find(params[:id])

    if @user_avatar.update(user_params) 
      redirect_to job_seeker_profiles_path
    else
      redirect_to job_seeker_profiles_path
    end
  end

  private

  def user_params
    params.require(:user_avatar).permit(:image, :crop_x, :crop_y, :crop_w, :crop_h)
  end
end