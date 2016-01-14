class UsersController < ApplicationController 
  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)    
    if @user.save 
      if @user.kind == 'job seeker'
        session[:user_id] = @user.id 
        redirect_to job_seeker_jobs_path
      else
        if params[:invitation_token].present?
          invitation = Invitation.where(token: params[:invitation_token]).first
          @user.update_attribute(:company_id, invitation.company_id)
          redirect_to login_path
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
    binding.pry
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

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :kind)
  end
end