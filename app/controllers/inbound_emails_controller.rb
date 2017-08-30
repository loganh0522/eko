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
    render text: params[:validationToken]

    # respond_to do |format|
    #   format.html { render nothing: true, status: 200, content_type: "text/plain" }
    # end
    return
  end


end

# https://prod-talentwiz.herokuapp.com/incoming_email
