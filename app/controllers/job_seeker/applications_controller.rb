class JobSeeker::ApplicationsController < JobSeekersController 
  before_filter :require_user

  def create 
    job = Job.find(params[:application][:job_id])  

    if !current_user_applied?(job)

      @application = Application.new(application_params)

      if @application.save 
        flash[:success] = "Your application has been submitted"
        track_activity @application
        redirect_to job_seeker_jobs_path
      else
        flash[:error] = "Something went wrong please try again"
      end
    else
      flash[:error] = "You have already applied to this job"
      redirect_to job_seeker_jobs_path
    end
  end

  private 

  def application_params 
    params.require(:application).permit(:user_id, :job_id, question_answers_attributes: [:id, :body, :question_id, :question_option_id])
  end

  def create_application
    Application.create(user: current_user, job: job) unless current_user_applied?(job)
  end

  def current_user_applied?(job)
    current_user.applications.map(&:job_id).include?(job.id)
  end
end