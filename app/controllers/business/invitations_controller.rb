class Business::InvitationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  def create
    @invitation = Invitation.create(invitation_params.merge!(inviter_id: current_user.id, company_id: current_company.id))
    
    if @invitation.save 
      AppMailer.send_invitation_email(@invitation, current_user, current_company).deliver
      flash[:success] = "An invitaion has been sent to: {@invitation.recipient_email}"
      redirect_to business_users_path
    else 
      flash[:error] = "You must enter a valid E-mail before sending an invitation."
      redirect_to business_users_path
    end

  end

  private 

  def invitation_params 
    params.require(:invitation).permit(:recipient_email)
  end
end