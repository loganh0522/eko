class AppMailer < ActionMailer::Base
  def send_invitation_email(invitation, current_user, current_company)
    @invitation = invitation 
    @user = current_user
    @current_company = current_company
    mail to: invitation.recipient_email, from: "no-reply@talentwiz.com", subject: "Invitation to Join #{current_company.name} Team"
  end

  def send_applicant_message(token, message, job, recipient, current_company)
    @message = message
    @recipient = recipient
    @job = job 
    @current_company = current_company
    mail to: recipient.email, from: "application-" + token + "@sys.talentwiz.ca", subject: "#{@message.subject}"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Please reset your password"
  end
end