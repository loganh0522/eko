class CompaniesController < ApplicationController 
  layout :set_layout
  before_filter :get_subdomain_company, only: [:index, :show]

  def new 
    @company = Company.new
    @user = @company.users.build
  end

  def create 
    @company = Company.new(company_params)

    if @company.save
      @user = @company.users.first
      @user.update_attributes(role: "Admin", kind: "business")
      @company.update_attribute(:subscription, 'trial')
      
      EmailSignature.create(user_id: @user.id, signature: "#{@user.first_name} #{@user.last_name}") 
      session[:user_id] = @user.id
      session[:company_id] = @company.id
      redirect_to business_root_path
    else
      render :new
    end
  end

  def index 
    @companies = @company.subsidiaries 
  end

  def show
    @company = Company.find(params[:id])
  end

  private

  def company_params 
    params.require(:company).permit(:name, :website, :kind, :size, :location,
      users_attributes: [:id, :first_name, :last_name, :email, :password, :phone])
  end 

  def render_errors(candidate)
    @errors = []
    candidate.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def get_subdomain_company
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain) 
      @company = @job_board.company
    end
  end

  def set_layout
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain)

      if @job_board.kind == "association"
        "association_portal"
      elsif @job_board.kind == "basic"
        "career_portal"
      else
        "advanced_career_portal"
      end
    else
      'frontend_job_seeker'
    end
  end
end