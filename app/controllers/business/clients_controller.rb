class Business::ClientsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @client = Client.new
  end

  def new 
    @client = Client.new
  end

  def create
  end

  def edit
  end

  def update
  end
  def destory

  end

end