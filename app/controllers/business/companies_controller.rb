class Business::CompaniesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  include AuthHelper
  
  def index
    @company = current_company
  end

  def new
    @company = Company.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @company = Company.new(company_params)
    
    respond_to do |format| 
      if @company.save
        @subsidiary = Subsidiary.create(subsidiary_id: @company.id, company_id: current_company.id )
        format.js
      else
        render_errors(@company)
        format.js
      end
    end
  end
  
  def edit 
    @company = current_company

    respond_to do |format|
      format.js
    end
  end

  def update
    @company = current_company
    @company.update(company_params)
    
    respond_to do |format|
      format.js
    end
  end

  def show
    @company = current_company
    @rooms = current_company.rooms
    @login_url = get_room_login_url
  end

  def change_current_company
    session[:company_id] = nil
    session[:company_id] = params[:id]
    redirect_to root_path
  end

  private 

  def company_params
    params.require(:company).permit(:name, :website, :kind, :address, :location, :size)
  end

  def render_errors(error)
    @errors = []
    error.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end