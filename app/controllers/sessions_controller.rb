class SessionsController < ApplicationController 

  def new 
    redirect_to business_root_path if current_user
  end

  def create 
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password]) && user.kind == 'business'
      session[:user_id] = user.id
      session[:company_id] = user.company.id
      flash[:notice] = "You've logged in!"
      redirect_to business_root_path
    elsif user && user.authenticate(params[:password]) && user.kind == 'job seeker'
      session[:user_id] = user.id
      flash[:notice] = "You've logged in!"
      redirect_to job_seeker_jobs_path
    else 
      flash[:error] = "Either your Username or Password is incorrect."
      render :new
    end
  end

  def destroy 
    session[:user_id] = nil 
    session[:company_id] = nil
    redirect_to login_path
  end
end