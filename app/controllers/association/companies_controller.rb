class Business::CompaniesController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index 
    @companies = current_company.companies.paginate(page: params[:page], per_page: 10)
  end
  
  def show 
    @company = Company.find(params[:id])
     
    respond_to do |format|
      format.js
    end
  end

  def new 
    @company = Company.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @company = Company.new(client_params)

    respond_to do |format|
      if @company.save
        @companies = current_company.companies.paginate(page: params[:page], per_page: 10)
        format.js
      else 
        render_errors(company)
        format.js
      end
    end
  end

  def edit
    company = Company.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update(client_params)
        @companies = current_company.companies.paginate(page: params[:page], per_page: 10)
      else 
        render_errors(company)
      end

      format.js
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy

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