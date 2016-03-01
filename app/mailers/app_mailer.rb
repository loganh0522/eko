class AppMailer < ActionMailer::Base
  def send_invitation_email(invitation, current_user, current_company)
    @invitation = invitation 
    @user = current_user
    @current_company = current_company
    mail to: invitation.recipient_email, from: "no-reply@talentwiz.com", subject: "Invitation to Join #{current_company.name} Team"
  end

  def send_applicant_message(message, job, applicant, current_company)
    @message = message
    @applicant = applicant
    @job = job 
    @current_company = current_company
    mail to: applicant.email, from: "applications@talentwiz.com", subject: "#{current_company.name}: #{job.title}"
  end
end