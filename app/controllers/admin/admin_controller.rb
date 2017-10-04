class AdminController < ApplicationController 
  before_filter {|c| Authorization.current_user = c.current_user}

  def owned_by_user
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('')
  end

  def owned_by_company
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('').constantize

    if class_name.find(params[:id]).company != current_company
      flash[:danger] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end   
  end

  def logged_in? 
    !!current_user 
  end

  def current_kind 
    current_user.kind
  end

  def require_user
    if !logged_in? 
      flash[:error] = "Must be logged in."
      redirect_to login_path
    end
  end

end