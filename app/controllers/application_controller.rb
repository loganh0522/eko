class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :current_company, :current_kind

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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

  def belongs_to_company
    if current_user.company != current_company 
      flash[:error] = "Sorry, you do not have permission to access that!"
      redirect_to business_root_path
    end
  end

  def company_deactivated?
    if current_user.company.active == false
      flash[:danger] = "Sorry, your account has been deactivated, please update your payment information"
      redirect_to business_customers_path
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
end
