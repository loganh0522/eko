class UsersController < ApplicationController 
  def new 
    @user = User.new
    
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new_company
    @user = User.new
  end

  # def create
  #   @user = User.new(user_params)     
    
  #   if @user.save 
  #     if params[:invitation_token].present?
  #       handle_invitation
  #     else
  #       session[:user_id] = @user.id 
  #       redirect_to new_company_path
  #     end
  #   else
  #     respond_to do |format| 
  #       format.js {render_errors(@user)}
  #       format.html {render :new}
  #     end
  #   end
  # end

  def create 
    @user = User.new(user_params)     
    
    if @user.save 
      if params[:invitation_token].present?
        handle_invitation
      else
        @company = @user.companies.first
        @user.update_attributes(role: "Admin", kind: "business")
        @company.update_attribute(:subscription, 'trial')
      
        EmailSignature.create(user_id: @user.id, signature: "#{@user.first_name} #{@user.last_name}") 
        
        session[:user_id] = @user.id
        session[:company_id] = @company.id
        redirect_to business_root_path
      end
    else
      binding.pry
      render :new_company
    end
  end

  def new_job_seeker
    @user = User.new
  end

  def create_job_seeker
    @user = User.new(user_params.merge!(kind: 'job seeker'))   


    respond_to do |format|
      if @user.save 
        session[:user_id] = @user.id 
        
        if request.subdomain.present? && request.subdomain != 'www'
          @job_board = JobBoard.find_by_subdomain!(request.subdomain)
          @company = @job_board.company
          @candidate = Candidate.where(email: @user.email, company: @company).first

          if !@candidate.present?
            Candidate.create(first_name: @user.first_name, last_name: @user.last_name,
              email: @user.email, user_id: @user.id, company_id: @company.id)
          end
        end

        format.js
        format.html {redirect_to job_seeker_create_profiles_path}
      else
        format.js { render_errors(@user) }
        format.html {render :new_job_seeker}
      end
    end
  end

  def sub_new_job_seeker
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @user = User.new
  end

  def new_with_invitation_token
    @invitation = Invitation.where(token: params[:token]).first
    
    if @invitation    
      @user = User.new(email: @invitation.recipient_email, first_name: @invitation.first_name,
        last_name: @invitation.last_name)
      @invitation_token = @invitation.token

      render :new
    else
      redirect_to expired_token_path
    end
  end

  def gmail_auth
    @auth = request.env['omniauth.auth']['credentials']
  end


  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :password, :password_confirmation, :kind, :phone, :location,
      )
  end


  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, 
      :email, :password, :password_confirmation, :phone,
      company_users_attributes: [ company_attributes: [ :id, :name, :location, :website, :size]])
  end

  def handle_invitation
    @invitation = Invitation.where(token: params[:invitation_token]).first
    
    if @invitation.permission_id == 0 || !@invitation.permission_id.present?
      @user.update_attributes(company_id: @invitation.company_id, 
        role: "Admin")
    else
      @user.update_attributes(company_id: @invitation.company_id, 
        permission_id: @invitation.permission_id)
    end

    if @invitation.job_id.present? 
      HiringTeam.create(user_id: @user.id, job_id: @invitation.job_id)
      session[:user_id] = @user.id
      session[:company_id] = @user.company.id 
      @invitation.destroy
      redirect_to business_root_path
    else
      session[:user_id] = @user.id 
      session[:company_id] = @user.company.id

      @invitation.destroy
      redirect_to business_root_path
    end
  end

  def set_layout
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    if @job_board.kind == "basic"
      "career_portal"
    else
      "advanced_career_portal"
    end
  end

  def render_errors(user)
    @errors = []
    user.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end