class Business::InvitationsController < ApplicationController
  layout "business"
  # filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  def index
    @invitations = current_company.invitations
    respond_to do |format|
      format.js
    end
  end

  def new
    @invitation = Invitation.new
    
    @job = Job.find(params[:job]) if params[:job].present?
    respond_to do |format|
      format.js
    end
  end
    
  def create
    @invitation = Invitation.create(invitation_params) 
    
    respond_to do |format|  
      if @invitation.save 
        AppMailer.send_invitation_email(@invitation, current_user, current_company).deliver
        flash[:success] = "An invitaion has been sent to: {@invitation.recipient_email}"
      else 
        render_errors(@invitation)
      end
      format.js
    end
  end

  private 

  def invitation_params 
    params.require(:invitation).permit(:user_id, :inviter_id, 
      :company_id, :message, :user_role, :recipient_email, :job_id,
      :first_name, :last_name)
  end
  
  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end