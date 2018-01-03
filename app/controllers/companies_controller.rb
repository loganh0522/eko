class CompaniesController < ApplicationController 
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

end