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


  def outlook_webhook   
    head 200, content_type: "text/plain", content_length: 7
    @token = params[:validationToken]
  end
end

https://prod-talentwiz.herokuapp.com/incoming_email
