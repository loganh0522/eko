class Business::UsersController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?
  
  def index 
    @invitation = Invitation.new
    @users = current_company.users.order(:first_name)
    @job_board = current_company.job_board
    
    respond_to do |format| 
      format.html 
      format.json { render json: @users.where("first_name like ?", "%#{params[:q]}%")}
    end
  end

  def edit
    @user = current_user
    @user_avatar = UserAvatar.new
    @avatar = @user.user_avatar
    
    if request.env['omniauth.auth'].present? 
      @auth = request.env['omniauth.auth']['credentials']
      GoogleToken.create(
        access_token: @auth['token'],
        refresh_token: @auth['refresh_token'],
        expires_at: Time.at(@auth['expires_at']).to_datetime,
        user_id: current_user.id
        )
    end
  end


  def gmail_auth
    @auth = request.env['omniauth.auth']['credentials']
  end
end