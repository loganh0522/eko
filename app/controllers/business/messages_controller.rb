class Business::MessagesController < ApplicationController 
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_messageable, except: [:new, :destroy, :update, :multiple_messages]
  before_filter :new_messageable, only: [:new]
  include AuthHelper
  
  def new
    @message = Message.new
    
    if params[:application_id].present?  
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
    elsif params[:client_contact_id].present? 
      @client = Client.find(params[:client_id])
      @contact = ClientContact.find(params[:client_contact_id])    
    else params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
    end

    respond_to do |format|
      format.js
    end
  end

  def index   
    if params[:application_id].present?
      @candidate = Application.find(params[:application_id]).candidate
      @messages = @candidate.messages
    else
      token = current_user.outlook_token.access_token
      email = current_user.email
      @messages = OutlookWrapper::Mail.get_messages(token, email)
    end

    respond_to do |format| 
      format.js
      format.html
    end
  end


  def create 
    @message = @messageable.messages.build(user_id: current_user.id, body: params[:body], subject: params[:message][:subject])      
    candidate_email(@messageable)
    @token = @messageable.token  

    if params[:job_id].present? 
      send_email(@token, @message, @job, @email, current_company)
    else
      send_email(@token, @message, 'job', @email, current_company)
    end

    if @message.save 
      track_activity(@message) 
      @messages = @messageable.messages
      respond_to do |format| 
        format.js 
      end
    end
  end

  def multiple_messages    
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @candidate = Candidate.find(id)
      @message = @candidate.messages.build(user_id: current_user.id, body: params[:body], subject: params[:subject])
      @token = @candidate.token

      if @candidate.manually_created == true
        @recipient = @candidate
      else
        @recipient = @candidate.user
      end
      
      if params[:job_id].present?
        @job = Job.find(params[:job_id])
        AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
      else 
        AppMailer.send_applicant_message(@token, @message, 'job', @recipient, current_company).deliver
      end
      track_activity(@message, "create")
    end
    
    respond_to do |format|
      format.js
    end
  end

  private

  def load_messageable
    if request.path.split('/')[-3..-1][1] == "business"
      @messageable = current_user
    else
      resource, id = request.path.split('/')[-3..-1]
      @messageable = resource.singularize.classify.constantize.find(id)
    end
  end

  def new_messageable
    resource, id = request.path.split('/')[-4..-2]
    @messageable = resource.singularize.classify.constantize.find(id)
  end

  def candidate_email(candidate)
    if candidate.user.present? 
      @email = candidate.user
    else
      @email = candidate
    end
    return @email
  end

  def send_email(token, message, job, recipient, current_company)
    if current_user.google_token.present? 
      @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
      GoogleWrapper::Gmail.send_message(@email, current_user, message)
    else 
      AppMailer.send_applicant_message(token, message, job, recipient, current_company).deliver
    end
  end

  # def get_thread
  #   service.get_user_thread('me', "15b4e83fccf315c4").messages.first.payload.body
  # end

  def get_application_thread
    @messages.each do |message| 
      if message.thread_id.present? 
        @thread = GoogleWrapper::Gmail.get_message_thread(message.thread_id, current_user)
        @messages = @thread.messages

        # @messages = []
        # @thread_messages.each do |message|
        #   @email = {}
        #   @email[:body] = message.payload.body.data
        #   message.payload.headers.each do |header| 
        #     if header.name == "Date" || "From" || "To" || "Date" || 
      end
    end
  end

end