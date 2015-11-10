class CompaniesController < ApplicationController 

  def new 
    @company = Company.new
  end

  def create 
    @company = Company.new(company_params)

    if @company.save? 
      flash[:notice] = "Thanks for joining #{@company.name}"
      redirect_to backend_path
    else
      render :new
    end
  end

  private

  def company_params 
    params.require(:company).permit(:name, :website)
  end 
end