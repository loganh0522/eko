class Business::SubsidiariesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company

  def index
    subsidiary = Subsidiary.find(params[:id])
  end

  def new
    @subsidiary = Subsidiary.new
  end

  def create
    @subsidiary = Subsidiary.new(sub_params)
    @subsidiary.company = current_company

    if @subsidiary.save 
      flash[:notice] = "Your subsidiary has been created"
      redirect_to business_locations_path
    else
      render :new
    end
  end

  def show
    @subsidiary = Subsidiary.find(params[:id])
    @location = Subsidiary.find(params[:id]).locations
  end


  private 

  def sub_params
    params.require(:subsidiary).permit(:name)
  end
end