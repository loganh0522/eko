class Business::ClientsController < ApplicationController
  filter_access_to :all
  filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @client = Client.new
    @clients = current_company.clients
  end

  def show
    @client = Client.find(params[:id])
    @contact = ClientContact.new
    @contacts = @client.client_contacts
    @jobs = @client.jobs
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
        @clients = current_company.clients
        format.js
      end
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
      if @client.update(job_board_header_params)
        format.js
      end
    end
  end

  def destory

  end

  private

  def client_params
    params.require(:client).permit(:company_id, :company_name, :website, :address, :user_id)
  end
end