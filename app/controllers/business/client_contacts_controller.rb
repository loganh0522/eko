class Business::ClientContactsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def show 
    @contact = ClientContact.find(params[:id])
    @client = Client.find(params[:client_id])
    @message = Message.new
    @comment = Comment.new
  end

  def new 
    @contact = ClientContact.new
    @client = Client.find(params[:client_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    @contact = ClientContact.new(client_params)

    respond_to do |format|
      if @contact.save
        format.js
      end
    end
  end

  def edit
    @contact = ClientContact.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @contact = ClientContact.find(params[:id])

    respond_to do |format|
      if @contact.update(job_board_header_params)
        format.js
      end
    end
  end

  def destory

  end

  private

  def client_params
    params.require(:client_contact).permit(:client_id, :first_name, :last_name, :email, :user_id)
  end
end