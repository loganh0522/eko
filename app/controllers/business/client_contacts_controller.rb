class Business::ClientContactsController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index 
    @client = Client.find(params[:client_id])
    @contacts = @client.client_contacts.paginate(page: params[:page], per_page: 10)
  end
  
  def show 
    @contact = ClientContact.find(params[:id])
     
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
        @contacts = @client.client_contacts.paginate(page: params[:page], per_page: 10)
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
    @client = @contact.client

    respond_to do |format|
      if @contact.update(client_params)
        @contacts = @client.client_contacts.paginate(page: params[:page], per_page: 10)
      else 
        render_errors(@contact)
      end

      format.js
    end
  end

  def destroy
    @contact = ClientContact.find(params[:id])
    @contact.destroy

    respond_to do |format| 
      format.js
    end
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