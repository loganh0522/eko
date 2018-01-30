class UsersController < ApplicationController 
  def new 
    @user = User.new
    
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @user = User.new(user_params)     
    
    if @user.save 
      if params[:invitation_token].present?
        handle_invitation
      else
        session[:user_id] = @user.id 
        redirect_to new_company_path
      end
    else
      respond_to do |format| 
        format.js {render_errors(@user)}
        format.html {render :new}
      end
    end
  end

  def new_job_seeker
    @user = User.new
  end

  def create_job_seeker
    @user = User.new(user_params.merge!(kind: 'job seeker'))   

    respond_to do |format|
      if @user.save 
        session[:user_id] = @user.id 
        format.js
        format.html {redirect_to job_seeker_create_profiles_path}
      else
        format.js { render_errors(@user) }
        format.html {render :new_job_seeker}
      end
    end
  end

  def sub_new_job_seeker
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @user = User.new
  end

  def new_with_invitation_token
    @invitation = Invitation.where(token: params[:token]).first
    if @invitation    
      @user = User.new(email: @invitation.recipient_email)
      @invitation_token = @invitation.token
      render :new
    else

      redirect_to expired_token_path
    end
  end

  def gmail_auth
    @auth = request.env['omniauth.auth']['credentials']
  end


  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :password, :password_confirmation, :kind, :phone, :location)
  end

  def handle_invitation
    @invitation = Invitation.where(token: params[:invitation_token]).first
    @user.update_attributes(company_id: @invitation.company_id, role: @invitation.user_role)
    
    if @invitation.job_id.present? 
      HiringTeam.create(user_id: @user.id, job_id: @invitation.job_id)
      session[:user_id] = @user.id
      session[:company_id] = @user.company.id 
      @invitation.destroy
      redirect_to business_root_path
    else
      session[:user_id] = @user.id 
      session[:company_id] = @user.company.id
      @invitation.destroy
      redirect_to business_root_path
    end
  end

  def set_layout
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    if @job_board.kind == "basic"
      "career_portal"
    else
      "advanced_career_portal"
    end
  end

  def render_errors(user)
    @errors = []
    user.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end