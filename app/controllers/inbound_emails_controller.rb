class InboundEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @token = params[:recipient].split('-').last.split('@').first
    @candidate = Candidate.find_by(token: @token)
    @msg_body = params["stripped-text"]


    if @candidate.present? 
      @message = @candidate.messages.build(body: @msg_body, candidate_id: @candidate.id)
    end

    head 200
  end
end