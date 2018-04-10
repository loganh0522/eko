class Business::InvitationsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index
    if params[:subsidiary].present?
      @subsidiary = Subsidiary.find(params[:subsidiary])
      @invitations = @subsidiary.subsidiary.invitations
    else
      @invitations = current_company.invitations
    end

    respond_to do |format|
      format.js
    end
  end

  def new
    @invitation = Invitation.new
    @job = Job.find(params[:job]) if params[:job].present?
    
    if params[:subsidiary].present?
      @subsidiary = Subsidiary.find(params[:subsidiary]) 
      @company = @subsidiary.subsidiary
    else
      @company = current_company
    end
    
    respond_to do |format|
      format.js
    end
  end
    
  def create
    if params[:subsidiary].present?
      @company = Subsidiary.find(params[:subsidiary]).subsidiary
      @invitation = Invitation.create(invitation_params.merge!(company: @company, user: current_user)) 
    else
      @invitation = Invitation.create(invitation_params.merge!(company: current_company, user: current_user)) 
    end
    
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

  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.js
    end
  end

  private 

  def invitation_params 
    params.require(:invitation).permit(:user_id, :inviter_id, :permission_id,
      :company_id, :message, :recipient_email, :job_id,
      :first_name, :last_name)
  end
  
  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end