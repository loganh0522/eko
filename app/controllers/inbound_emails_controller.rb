class InboundEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :outlook_webhook, :gmail_webhook]

  def create
    @token = params[:recipient].split('-').last.split('@').first
    @candidate = Candidate.find_by(token: @token)
    @msg_body = params["stripped-text"]


    if @candidate.present? 
      @message = @candidate.messages.build(body: @msg_body, candidate_id: @candidate.id).save
    end

    head 200
  end

  def gmail_webhook
    head :no_content
    @messageData = ActiveSupport::JSON.decode(Base64.decode64("eyJlbWFpbEFkZHJlc3MiOiJob3VzdG9uQHRhbGVudHdpei5jYSIsImhpc3RvcnlJZCI6MzE5NjE3fQ=="))
    @user = User.where(email: @messageData["emailAddress"])
    @historyID = @messageData["historyId"]

    service.list_user_histories('me', start_history_id: '319617', label_id: ['INBOX'])

    # GoogleWrapper::Gmail.create_message(params[:message][:data])
  end

  def outlook_webhook
    if params[:validationToken].present? 
      render text: params[:validationToken]
      head 200
    else 
      head 200

      if params[:value].present? 
        @subId = params[:value].first[:subscriptionId]
        @msgId = params[:value].first[:resourceData][:id]
        @message = OutlookWrapper::Mail.create_message_object_from_outlook(@subId, @msgId) 
      end
    end
  end

end

# https://prod-talentwiz.herokuapp.com/incoming_email
