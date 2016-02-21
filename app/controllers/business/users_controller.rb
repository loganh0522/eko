class Business::UsersController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  
  def index 
    @invitation = Invitation.new
    @users = current_company.users.order(:first_name)
    @job_board = current_company.job_board
    
    respond_to do |format| 
      format.html 
      format.json { render json: @users.where("first_name like ?", "%#{params[:q]}%")}
    end
  end
end