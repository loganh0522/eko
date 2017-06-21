class Business::InvitationsController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def new
    @invitation = Invitation.new
    @job = Job.find(params[:job]) if params[:job].present?
    respond_to do |format|
      format.js
    end
  end
 
  def index
    
  end
    
  def create
    create_invitation

    respond_to do |format|
      format.js
    end
  end

  private 

  def invitation_params 
    params.require(:invitation).permit(:user_id, :inviter_id, :company_id, :message, :user_role, :recipient_email, :job_id)
  end

  def create_invitation
    @invitation = Invitation.create(invitation_params)   
    if @invitation.save 
      AppMailer.send_invitation_email(@invitation, current_user, current_company).deliver
      flash[:success] = "An invitaion has been sent to: {@invitation.recipient_email}"
    else 
      flash[:error] = "You must enter a valid E-mail before sending an invitation."
    end
  end
end