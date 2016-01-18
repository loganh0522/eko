class Business::LocationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  def index
    @subsidiaries = current_company.subsidiaries
    @company = current_company
    @location = current_company.locations
  end

  def new 
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)

    if params[:subsidiary].present? 
      subsidiary = Subsidiary.find(params[:subsidiary])
      @location.subsidiary = subsidiary
    else
      @location.company = current_company
    end

    if @location.save    
      redirect_to business_locations_path
    else
      render :new
    end
  end
  
  def new_for_subsidiary
    subsidiary = Subsidiary.where(id: params[:subsidiary_id]).first

    if subsidiary 
      @subsidiary = subsidiary.id
      @location = Location.new
      render :new
    else 
      redirect_to business_root_path
    end
  end

  def show

  end

  private 

  def location_params
    params.require(:location).permit(:name, :address, :city, :country, :state, :number)
  end
end