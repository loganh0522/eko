class Business::MessagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
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
      @application = Application.find(params[:application_id])
      @messages = @application.messages
    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @application = @candidate.applications.first
      @messages = @application.messages
    else
      @messages = current_user.messages.all
      get_application_thread
    end

    respond_to do |format| 
      format.js
      format.html
    end
  end


  def create 
    if params[:client_contact_id].present?   
      @recipient = ClientContact.find(params[:client_contact_id])
      @message = @recipient.messages.build(user_id: current_user.id, body: params[:body], subject: params[:message][:subject])   
    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      candidate_email(@candidate)
      @message = @candidate.messages.build(user_id: current_user.id, body: params[:body], subject: params[:message][:subject])
      send_email(@candidate.token, @message, 'job', @email, current_company)
    else 
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
      @user = @application.applicant
  
      @messages = @application.messages
      @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')


      @recipient = @application.applicant
      @token = @application.token      
      @message = @application.messages.build(user_id: current_user.id, body: params[:body], subject: params[:message][:subject]) 
      
      send_email(@token, @message, @job, @recipient, current_company)
    end

    if @message.save 
      track_activity(@message) 
      respond_to do |format| 
        format.js 
      end
    end
  end

  # def get_thread
  #   service.get_user_thread('me', "15b4e83fccf315c4").messages.first.payload.body
  # end
  def send_multiple_messages    
    applicant_ids = params[:applicant_ids].split(',')

    applicant_ids.each do |id| 
      @application = Application.find(id)
      @job = Job.find(@application.job_id)
      @message = Message.create(body: params[:body], application_id: @application.id, user_id: current_user.id)
      @recipient = @application.applicant
      @token = @application.token
      AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
    end
    track_activity(@message, "create")
    redirect_to :back
  end

  private

  def candidate_email(candidate)
    if candidate.user.present? 
      @email = candidate.user
    else
      @email = candidate
    end
    return @email
  end

  def send_email(token, message, job, recipient, current_company)
    if @current_user.google_token.present? 
      @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
      GoogleWrapper::Gmail.send_message(@email, current_user, message)
    else 
      AppMailer.send_applicant_message(token, message, job, recipient, current_company).deliver
    end
  end

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