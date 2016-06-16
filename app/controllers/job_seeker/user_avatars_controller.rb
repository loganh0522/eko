class JobSeeker::UserAvatarsController < JobSeekersController

  def new 

  end

  def create
    @user_avatar = UserAvatar.new(user_params)
    @user_avatar.user = current_user

    if @user_avatar.save 
      redirect_to job_seeker_profiles_path
    else 
      flash[:danger] = "Sorry, something went wrong, please try again."
      redirect_to job_seeker_profiles_path
    end
  end

  def edit

  end
  
  def update

  end

  def show

  end

  def crop

  end

  private

  def user_params
    params.require(:user_avatar).permit(:image)
  end
end