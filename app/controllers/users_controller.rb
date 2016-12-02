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
          redirect_to profile_path(@user)
        else
          redirect_to job_seeker_jobs_path
        end
      else
        if params[:invitation_token].present?
          invitation = Invitation.where(token: params[:invitation_token]).first
          @user.update_attribute(:company_id, invitation.company_id)
          if invitation.job.present? 
            HiringTeam.create(user_id: @user.id, job_id: invitation.job)
            redirect_to login_path
          else
            redirect_to login_path
          end
        else
          session[:user_id] = @user.id 
          redirect_to new_company_path
        end
      end
    else
      render :new
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
    invitation = Invitation.where(token: params[:token]).first
    if invitation    
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
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
    params.require(:user).permit(:first_name, :last_name, :email, :password, :kind)
  end
end