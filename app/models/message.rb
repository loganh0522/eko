class Message < ActiveRecord::Base 
  belongs_to :user
  belongs_to :messageable, polymorphic: true
  belongs_to :conversation


  has_one :activity, as: :trackable, :dependent => :destroy
  
  validates_presence_of :subject, :body
  after_create :send_email, if: :email_id_present?

  def send_email
    if self.user.google_token.present? 
      @body = Liquid::Template.parse(self.body).render('recipient' => self.messageable, 'company' => self.messageable.company)
      @email = Mail.new(to: self.messageable.email, from: self.user.email, subject: self.subject, body: @body, content_type: "text/html")
      
      GoogleWrapper::Gmail.send_message(@email, self.id, self.user)

    elsif self.user.outlook_token.present?
      @email = Liquid::Template.parse(self.body).render('recipient' => self.messageable, 'company' => self.messageable.company)
      OutlookWrapper::Mail.send_message(self.user, self.id, self.subject, @email, self.messageable.email)
    else 
      AppMailer.send_applicant_message(self.candidate.token, self.body, self.job, self.candidate.email, self.user.company).deliver
    end
  end

  def email_id_present?
    !self.email_id.present?
  end
end