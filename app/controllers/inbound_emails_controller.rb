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
    @messageData = ActiveSupport::JSON.decode(Base64.decode64(params[:message][:data]))
    @user = User.where(email: @messageData["emailAddress"]).first
    @historyId = @messageData["historyId"]
    @current_id = @user.google_token.history_id

    if @historyId != @current_id
      GoogleWrapper::Gmail.create_message(@historyId, @user, @current_id)
    end
  end

  def outlook_webhook
    if params[:validationToken].present? 
      render plain: params[:validationToken]
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


