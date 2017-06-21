class UsersController < ApplicationController 
  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)     
    if @user.save 
      if @user.kind == 'job seeker'
        session[:user_id] = @user.id 
        if request.subdomain.present? 
          redirect_to new_profile_path
        else
          redirect_to new_job_seeker_profile_path
        end
      else
        EmailSignature.create(user_id: @user.id, signature: "#{@user.first_name} #{@user.last_name}")      
        if params[:invitation_token].present?
          handle_invitation
        else
          session[:user_id] = @user.id 
          redirect_to new_company_path
        end
      end
    else
      if @user.kind == 'job seeker'
        render :new_job_seeker
      else
        render :new
      end
    end
  end

  def new_job_seeker
    @user = User.new
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
    params.require(:user).permit(:first_name, :last_name, :email, :role, :password, :kind, :phone, :location)
  end

  def handle_invitation
    @invitation = Invitation.where(token: params[:invitation_token]).first
    @user.update_attributes(company_id: @invitation.company_id, role: @invitation.user_role)
    @invitation.update_attribute(:status, "complete")
    
    if @invitation.job_id.present? 
      HiringTeam.create(user_id: @user.id, job_id: @invitation.job_id)
      session[:user_id] = @user.id
      session[:company_id] = @user.company.id 
      redirect_to business_root_path
    else
      session[:user_id] = @user.id 
      session[:company_id] = @user.company.id
      redirect_to business_root_path
    end
  end
end