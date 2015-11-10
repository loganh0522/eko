class SessionsController < ApplicationController 

  def new 

  end

  def create 
    user = User.find_by(email: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You've logged in!"
      redirect_to root_path
    else 
      flash[:error] = "Either your Username or Password is incorrect."
      redirect_to register_path
    end
  end
end