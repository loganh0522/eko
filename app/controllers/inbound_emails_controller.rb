class InboundEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @token = params[:recipient].split('-').last.split('@').first
    @application = Application.find_by(token: @token)
    @msg_body = params["stripped-text"]


    if @application.present? 
      @message = Message.create(body: @msg_body, application_id: @application.id, user_id: @application.user_id)
    end

    head 200
  end
end