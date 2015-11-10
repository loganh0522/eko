class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

   def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] #memoization
  end

  def logged_in? 
    !!current_user 
  end

  def require_user
    if !logged_in? 
      flash[:error] = "Must be logged in."
      redirect_user root_path
    end
  end

end
