class CreateProfilesController < ApplicationController 
  include Wicked::Wizard
  steps :personal, :experience

  def index

  end

  def show
    @user = current_user
    render_wizard
  end
  
  def update
    @user = current_user
    @user.attributes = params[:user]
    render_wizard @user
  end
end