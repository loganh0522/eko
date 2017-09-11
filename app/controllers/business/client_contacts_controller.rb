class Business::ClientContactsController < ApplicationController
  layout "business"
  filter_access_to :all
  filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index 
    @client = Client.find(params[:client_id])
    @contact = ClientContact.new
    @contacts = @client.client_contacts
  end
  
  def show 
    @contact = ClientContact.find(params[:id])
    @client = Client.find(params[:client_id])
 
    respond_to do |format|
      format.js
    end
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
    @client = Client.find(params[:client_id])

    respond_to do |format|
      if @contact.save
        @contacts = @client.client_contacts
        format.js
      else 
        render_errors(@contact)
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

  def render_errors(contact)
    @errors = []
    contact.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def client_params
    params.require(:client_contact).permit(:client_id, :first_name, :last_name, :email, :phone, :user_id)
  end
end