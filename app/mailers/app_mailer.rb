class AppMailer < ActionMailer::Base
  def send_invitation_email(invitation, current_user, current_company)
    @invitation = invitation 
    @user = current_user
    mail to: invitation.recipient_email, from: "no-reply@talentwiz.com" subject: "Invitation to Join #{current_company.name} Team"
  end
end