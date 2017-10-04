class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :current_company, :current_kind, :user_logged_in, 
    :profile_sign_up_complete, :belongs_to_company, :has_applied?
  
  before_filter {|c| Authorization.current_user = c.current_user}

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_company
    @current_company ||= Company.find(session[:company_id]) if session[:company_id]
  end

  def permission_denied
    flash[:danger] = "Sorry, you are not allowed to access that page"
    redirect_to root_url
  end

  def user_logged_in
    if current_user.present? && current_user.kind == 'business'
      redirect_to business_root_path
    elsif current_user.present? && current_user.kind == 'job seeker'
      redirect_to job_seeker_root_path
    end
  end
  
  def belongs_to_user
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('').constantize

    if class_name.find(params[:id]).user != current_user
      flash[:danger] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end
  end

  def user_to_user
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('').constantize

    if class_name.find(params[:id]) != current_user
      flash[:danger] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end
  end

  def owned_by_company
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('').constantize

    if class_name.find(params[:id]).company != current_company
      flash[:notice] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end   
  end

  def logged_in? 
    !!current_user 
  end

  def current_kind 
    current_user.kind
  end

  def require_user
    if !logged_in? 
      flash[:error] = "Must be logged in."
      redirect_to login_path
    end
  end

  def profile_sign_up_complete
    if current_user.present? && current_user.profile.present? == false && current_user.kind == "job seeker"
      if request.subdomain.present? 
        redirect_to new_profile_path
      else
        redirect_to new_job_seeker_profile_path
      end
      flash[:danger] = "Please complete your profile before you continue."
    end
  end

  def belongs_to_company
    if current_user.company != current_company 
      flash[:error] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end
  end

  # def belongs_to_company
  #   if !current_user.companies.include?(current_company)
  #     flash[:error] = "Sorry, you do not have permission to access that!"
  #     redirect_to business_root_path
  #   end
  # end

  def company_deactivated?
    if current_company.active == false && current_company.subscription == "trial"
      flash[:danger] = "Your 14-Day Trial has ended. Please select a plan to continue use."
      redirect_to business_plan_path
    elsif current_company.active == false 
      flash[:danger] = "Sorry, your subscription payment failed. Please update your payment information, and choose a new subscription."
      redirect_to business_customers_path
    end
  end

  def trial_over
    if current_company.created_at < (Date.today - 14.days) && current_company.subscription == "trial"
      current_company.update_attribute(:active, false)
    end
  end
 

  def has_a_scorecard
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.where(job_id: @job.id).first

    if @job.scorecard.present? 
      redirect_to edit_business_job_scorecard_path(@job.id, @scorecard.id)
    end
  end

  def track_multiple_activity(trackable, action = params[:action], applicants)
    if (params[:applicant_ids]).present?
      applicant_ids = params[:applicant_ids].split(',')
      applicant_ids.each do |id| 
        current_user.activities.create! action: action, trackable: trackable, application_id: id, company: current_company, job_id: @job.id
      end
    else
      current_user.activities.create! action: action, trackable: trackable
    end
  end

  def track_activity(trackable, action = params[:action], company=nil, candidate=nil, job=nil, stage = nil)
    current_user.activities.create! action: action, trackable: trackable, 
      company_id: company, job_id: job, stage_id: stage, candidate_id: candidate
  end

  def track_notification(trackable, action = params[:action])
    current_user.notifications.create! action: action, trackable: trackable, company: current_company
  end
end
