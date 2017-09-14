class InboundEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :outlook_webhook]

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

  end

  def outlook_webhook
    if params[:validationToken].present? 
      render text: params[:validationToken]
    else 
      head 200 
      
    end
  end

end

# https://prod-talentwiz.herokuapp.com/incoming_email
