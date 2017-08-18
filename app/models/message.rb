class Message < ActiveRecord::Base 
  belongs_to :user
  belongs_to :messageable, polymorphic: true
  belongs_to :conversation
  validates_presence_of :subject, :body

  after_create :send_email

  def send_email
    if self.user.google_token.present? 
      @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
      GoogleWrapper::Gmail.send_message(@email, current_user, message)
    elsif self.user.outlook_token.present?
      OutlookWrapper::Mail.send_message(self.user, self.subject, self.body, self.messageable.email)
    else 
      AppMailer.send_applicant_message(self.candidate.token, self.body, self.job, self.candidate.email, self.user.company).deliver
    end
  end
end