class Business::UserAvatarsController < ApplicationController
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
    @user_avatar = UserAvatar.new(user_params)

    respond_to do |format| 
      format.js
    end
  end

  def edit 

  end

  def update

  end

  def destroy

  end

  private

  def user_params
    params.require(:user_avatar).permit(:image, :user_id)
  end
end