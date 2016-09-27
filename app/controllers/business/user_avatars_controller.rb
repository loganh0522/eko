class Business::UserAvatarsController < ApplicationController

  def index

  end

  def new 

  end

  def create
    @user_avatar = UserAvatar.new(user_params)
    @user_avatar.user = current_user

    if @user_avatar.save 
      redirect_to edit_business_user_path(current_user.id)
    else 
      flash[:danger] = "Sorry, something went wrong, please try again."
      redirect_to edit_business_user_path(current_user.id)
    end
  end

  private

  def user_params
    params.require(:user_avatar).permit(:image)
  end
end