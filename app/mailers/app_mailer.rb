class AppMailer < ActionMailer::Base
  def send_invitation_email(invitation, current_user, current_company)
    @invitation = invitation 
    @user = current_user
    @current_company = current_company
    mail to: invitation.recipient_email, from: "no-reply@talentwiz.ca", subject: "Invitation to Join #{current_company.name} Team"
  end

  def send_interview_invitation(token, message, subject, job, recipient, current_company)
    @message = message
    @recipient = recipient
    @subject = subject
    @job = job 
    @current_company = current_company
    @token = token
    
    mail to: recipient, from: "application-" + token + "@sys.talentwiz.ca", subject: subject
  end

  def send_applicant_message(token, message, job, recipient, current_company)
    @message = message
    @recipient = recipient
    @job = job 
    @current_company = current_company

    mail to: recipient.email, from: "application-" + token + "@sys.talentwiz.ca", subject: "#{@message.subject}"
  end

  def send_contact_message(contact)
    @contact = contact
    mail to: "houston@talentwiz.ca", from: "no-reply@talentwiz.ca", subject: "Potential Customer Message"
  end

  def send_demo_request(demo)
    @demo = demo
    mail to: "houston@talentwiz.ca", from: "no-reply@talentwiz.ca", subject: "Company Demo Request"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "no-reply@talentwiz.ca", subject: "Please reset your password"
  end

  def send_job_posting_alert(order_item, posting_details)
    mail to: "houston@talentwiz.ca", from: "no-reply@talentwiz.ca", subject: order_item.name  body: posting_details
  end
end