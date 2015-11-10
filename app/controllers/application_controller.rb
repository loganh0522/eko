class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?. :current_user


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]

  def current_company
    @current_company ||= Company.find(session[:company_id]) if session[:company_id]
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
