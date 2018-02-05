class Business::ConversationsController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    @conversations = current_company.conversations
  end

  def show 
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages
    @candidate = @conversation.candidate
    

    respond_to do |format|
      format.js
    end 
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
  end
end