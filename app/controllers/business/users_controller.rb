class Business::UsersController < ApplicationController 
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  # before_filter :user_to_user, only: [:show, :edit, :update]
  include AuthHelper

  def index 
    if params[:term].present?
      @company_users = current_company.users.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
      render :json => @company_users.to_json 
    else
      @users = current_company.users
      @job_board = current_company.job_board
      
      respond_to do |format| 
        format.html 
        format.json { render json: @users.where("first_name like ?", "%#{params[:q]}%")}
      end
    end
  end

  def create_subscription
    OutlookWrapper::User.create_subscription(current_user)
  end

  def show
    @user = current_user
    @signature = current_user.email_signature
    @login_url = get_login_url

    if request.env['omniauth.auth'].present? 
      @auth = request.env['omniauth.auth']['credentials']
      GoogleToken.create(
        access_token: @auth['token'],
        refresh_token: @auth['refresh_token'],
        expires_at: Time.at(@auth['expires_at']).to_datetime,
        user_id: current_user.id
        )
    elsif params[:code].present? 
      token = get_token_from_code(params[:code])
      OutlookToken.create(
        access_token: token.token,
        refresh_token: token.refresh_token,
        expires_at: Time.now + token.expires_in.to_i.seconds,
        user_id: current_user.id
        )
      redirect_to business_user_path(current_user)
    end
  end

  def outlook_get_token
    OutlookWrapper::User.update_subscription(current_user)

    # token = get_token_from_code params[:code]

    # OutlookToken.create(
    #   access_token: token.token,
    #   refresh_token: token.refresh_token,
    #   expires_at: Time.now + token.expires_in.to_i.seconds,
    #   user_id: current_user.id
    #   )

    # OutlookWrapper::User.create_subscription(current_user)
    redirect_to business_user_path(current_user)
  end

  def edit
    @user = current_user
    
    respond_to do |format| 
      format.js
    end
  end

  def update
    @user = current_user
    
    respond_to do |format|
      if @user.update(user_params)
        format.js
      else
        render_errors(@user)
        format.js
      end
    end
  end

  def update_password
    @user = User.find(1)
    @user.password = params[:password]
    @user.save

    respond_to do |format| 
      format.js
    end
  end

  def destroy

  end

  def autocomplete
    render :json => User.search(params[:term], where: {company_id: current_company.id}, 
      fields: [{full_name: :word_start}])
  end

  def gmail_auth
    @auth = request.env['omniauth.auth']['credentials']
  end

  private

  def render_errors(comment)
    @errors = []
    comment.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

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