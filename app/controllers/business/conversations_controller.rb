class Business::ConversationsController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read
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
    # @messages = OutlookWrapper::User.create_subscription(current_user)

    respond_to do |format|
      format.js
    end 
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
  end
end