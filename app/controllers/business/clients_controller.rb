class Business::ClientsController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @clients = current_company.clients.paginate(page: params[:page], per_page: 10)

  end

  def show
    @client = Client.find(params[:id])
    @contacts = @client.client_contacts
  end

  def new 
    @client = Client.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        @clients = current_company.clients.paginate(page: params[:page], per_page: 10)       
      else 
        render_errors(@client)
      end
      format.js
    end
  end

  def edit
    @client = Client.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update(client_params)
        @clients = current_company.clients.paginate(page: params[:page], per_page: 10)
      else 
        render_errors(@client)
      end
      format.js
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format| 
      format.js
    end
  end

  def search 

  end

  private

  def render_errors(client)
    @errors = []
    client.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def client_params
    params.require(:client).permit(:company_id, :company_name, :website, :address, :user_id)
  end
end