class SessionsController < ApplicationController 
  def new 
    if current_user && current_kind == 'business'
      redirect_to business_root_path 
    elsif current_user && current_kind == 'job seeker'
      redirect_to job_seeker_jobs_path
    end
  end

  def create 
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password]) 
      if @user.kind == 'business'
        session[:user_id] = @user.id
        session[:company_id] = @user.company.id
        redirect_to business_root_path
      elsif @user.kind == 'job seeker'    
        session[:user_id] = @user.id
        flash[:notice] = "You've logged in!"     
        if request.subdomain.present? 
          redirect_to root_path
        else
          redirect_to job_seeker_jobs_path
        end
      end
    else 
      flash[:error] = "Either your Username or Password is incorrect."
      render :new
    end
  end

  def subdomain_new
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
  end

  def destroy 
    session[:user_id] = nil 
    session[:company_id] = nil
    if request.subdomain.present? 
      redirect_to root_path
    else
      redirect_to login_path
    end
  end
end