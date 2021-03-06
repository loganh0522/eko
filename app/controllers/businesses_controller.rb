class BusinessesController < ApplicationController 
  before_filter {|c| Authorization.current_user = c.current_user}

  def owned_by_user
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('')
  end

  def owned_by_company
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('').constantize

    if class_name.find(params[:id]).company != current_company
      flash[:danger] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end   
  end

  def current_company
    @current_company ||= Company.find(session[:company_id]) if session[:company_id]
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

  def has_a_questionairre 
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.where(job_id: @job.id).first

    if @job.questionairre.present? 
      redirect_to edit_business_job_questionairre_path(@job.id, @questionairre.id)
    end
  end

  def has_a_scorecard
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.where(job_id: @job.id).first

    if @job.scorecard.present? 
      redirect_to edit_business_job_scorecard_path(@job.id, @scorecard.id)
    end
  end

  # def track_multiple_activity(trackable, action = params[:action], applicants)
  #   current_user.activities.create! action: action, trackable: trackable, 
  # end

  def track_activity(trackable, action = params[:action])
    if (params[:application_id]).present?
      current_user.activities.create! action: action, trackable: trackable, application_id: params[:application_id], company: current_company, job_id: params[:job_id]    
    elsif (params[:applicant_ids]).present?
      applicant_ids = params[:applicant_ids].split(',')
      applicant_ids.each do |id| 
        current_user.activities.create! action: action, trackable: trackable, application_id: id, company: current_company, job_id: @job.id
      end
    else
      current_user.activities.create! action: action, trackable: trackable, company: current_company
    end
  end

  def track_notification(trackable, action = params[:action])
    current_user.notifications.create! action: action, trackable: trackable, company: current_company
  end
end