class Business::MessagesController < ApplicationController 
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_messageable, except: [:new, :index, :create, :destroy, :update, :multiple_messages, :new_multiple]
  before_filter :new_messageable, only: [:new] 
  
  # include AuthHelper

  def index
    @candidate = Candidate.find(params[:candidate_id])
    @conversation = @candidate.conversation if @candidate.conversation.present?
    @messages = @conversation.messages if @conversation.present?

    respond_to do |format| 
      format.js
      format.html
    end
  end

  def new
    @message = Message.new  

    # GoogleWrapper::Gmail.get_message(current_user, "16003fe8a0356c28" )
    
    respond_to do |format|
      format.js
    end
  end

  def create 
    @candidate = Candidate.find(params[:candidate_id])
    
    if @candidate.conversation.present? 
      @message = @candidate.messages.build(message_params.merge(conversation_id: @candidate.conversation.id))
    else 
      Conversation.create(candidate_id: @candidate.id, company_id: current_company.id)   
      @conversation = Candidate.find(params[:candidate_id]).conversation
      @message = @candidate.messages.build(message_params.merge(conversation_id: @conversation.id))
    end

    respond_to do |format| 
      if @message.save 
        track_activity @message, 'create', current_company.id, @candidate.id  
        @messages = @candidate.messages
        format.js 
      else
        render_errors(@message)
        format.js 
      end
    end
  end

  def new_multiple
    @message = Message.new

    respond_to do |format|
      format.js
    end
  end

  def multiple_messages   
    applicant_ids = params[:applicant_ids].split(',')
    applicant_ids.each do |id| 
      @candidate = Candidate.find(id)

      if @candidate.conversation.present? 
        @message = @candidate.messages.build(message_params.merge(conversation_id: @candidate.conversation.id)).save
      else 
        Conversation.create(candidate_id: @candidate.id, company_id: current_company.id)   
        @conversation = Candidate.find(id).conversation
        @message = @candidate.messages.build(message_params.merge(conversation_id: @conversation.id)).save
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  private

  def load_messageable
    resource, id = request.path.split('/')[-3..-1]
    @messageable = resource.singularize.classify.constantize.find(id)
  end

  def new_messageable
    resource, id = request.path.split('/')[-4..-2]
    @messageable = resource.singularize.classify.constantize.find(id)
  end

  def message_params 
    params.require(:message).permit(:body, :subject, :user_id, :candidate_id)
  end

  def render_errors(message)
    @errors = []
    message.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def get_application_thread
    @messages.each do |message| 
      if message.thread_id.present? 
        @thread = GoogleWrapper::Gmail.get_message_thread(message.thread_id, current_user)
        @messages = @thread.messages
      end
    end
  end
end