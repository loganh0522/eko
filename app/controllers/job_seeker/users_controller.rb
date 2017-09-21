class JobSeeker::UsersController < JobSeekersController 
  layout "job_seeker"
  before_filter :require_user
  before_filter :profile_sign_up_complete

  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      convert_location
      redirect_to job_seeker_profiles_path
    else
      redirect_to job_seeker_profiles_path
    end
  end

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :tag_line, :location,
      social_links_attributes: [:id, :url, :kind, :_destroy] )
  end

  def convert_location
    location = params[:user][:location].split(',')
    if location.count == 3
      @user.update_column(:city, location[0])
      @user.update_column(:province, location[1])
      @user.update_column(:country, location[2])
    else
      @user.update_column(:city, location[0])
      @user.update_column(:country, location[1])
    end
  end
end