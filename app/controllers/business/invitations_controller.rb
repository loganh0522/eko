class Business::InvitationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company


  def create
    if params[:invitation][:job].present? 
      @job = Job.find(params[:invitation][:job])
      create_invitation
      redirect_to new_business_job_hiring_team_path(@job)
    else 
      create_invitation
      redirect_to business_users_path
    end
  end

  private 

  def invitation_params 
    params.require(:invitation).permit(:recipient_email, :job)
  end

  def create_invitation
    @invitation = Invitation.create(invitation_params.merge!(inviter_id: current_user.id, company_id: current_company.id))   
    if @invitation.save 
      AppMailer.send_invitation_email(@invitation, current_user, current_company).deliver
      flash[:success] = "An invitaion has been sent to: {@invitation.recipient_email}"
    else 
      flash[:error] = "You must enter a valid E-mail before sending an invitation."
    end
  end
end