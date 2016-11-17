class CompaniesController < ApplicationController 
  
  def new 
    @company = Company.new
  end

  def create 
    @company = Company.new(company_params)

    if @company.save
      set_user(@company)
      create_career_portal(@company)
      @company.update_attribute(:subscription, 'trial')
      session[:company_id] = @company.id
      flash[:notice] = "Thanks for joining #{@company.name}"
      redirect_to business_root_path
    else
      render :new
    end
  end

  private

  def company_params 
    params.require(:company).permit(:name, :website)
  end 

  def set_user(company)
    current_user.update_attribute(:company_id, company.id)
  end

  def create_career_portal(company)
    @subdomain = company.name.parameterize("_")
    JobBoard.create(company_id: company.id, subdomain: @subdomain)
  end  
end