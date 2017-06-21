class Business::UsersController < ApplicationController 
  filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index 
    if params[:term].present?
      @company_users = current_company.users.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
      render :json => @company_users.to_json 
    else
      @invitation = Invitation.new
      @users = current_company.users.order(:first_name)
      @job_board = current_company.job_board
      
      respond_to do |format| 
        format.html 
        format.json { render json: @users.where("first_name like ?", "%#{params[:q]}%")}
      end
    end
  end

  def show
    @user = current_user
    @user_avatar = UserAvatar.new
    @avatar = @user.user_avatar
    @signature = @user.email_signature
    
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

  def edit
    @user = current_user
    
    respond_to do |format| 
      format.js
    end
  end

  def update
    @user = current_user
    @user.update(user_params)
    
    respond_to do |format|
      format.js
    end
  end

  def gmail_auth
    @auth = request.env['omniauth.auth']['credentials']
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :password, :password_confirmation)
  end

  def user_google_token_present
    if @user.google_token.present? 
      @labels = GoogleWrapper::Gmail.get_messages(current_user)    
      @titles = []  
      @labels.messages.each do |label|
        @titles.append(GoogleWrapper::Gmail.get_message_titles(label, @user))
      end
    end
  end
end