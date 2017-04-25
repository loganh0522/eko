class Business::MessagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create 
    if params[:client_contact_id].present?   
      @recipient = ClientContact.find(params[:client_contact_id])
      @message = @recipient.messages.build(user_id: current_user.id, body: params[:body], subject: params[:message][:subject])   
    else 
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
      @user = @application.applicant
      
      @messages = @application.messages
      @recipient = @application.applicant
      @token = @application.token
      @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
      @message = @application.messages.build(user_id: current_user.id, body: params[:body], subject: params[:message][:subject]) 
      
      if @current_user.google_token.present? 
        @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
        GoogleWrapper::Gmail.send_message(@email, current_user)
      else 
        AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
      end
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
end