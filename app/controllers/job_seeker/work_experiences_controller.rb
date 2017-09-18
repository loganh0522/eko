class JobSeeker::WorkExperiencesController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new
    @profile = current_user.profile
    @work_experience = WorkExperience.new

    respond_to do |format|
      format.js
    end
  end
  
  def create 
    @profile = current_user.profile
    @positions = current_user.profile.work_experiences
    @work_experience = WorkExperience.new(position_params.merge!(profile: current_user.profile))
   
    respond_to do |format|
      if @work_experience.save
        @profile = current_user.profile
        @work_experiences = current_user.profile.work_experiences.sort_by{|work| [work.start_year, work.end_year] }.reverse
      else 
        render_errors(@work_experience) 
      end
      format.js
    end  
  end

  def edit 
    @profile = current_user.profile
    @positions = current_user.profile.work_experiences
    @work_experience = WorkExperience.find(params[:id])
  end

  def update
    @profile = current_user.profile
    @positions = current_user.profile.work_experiences
    @work_experience = WorkExperience.find(params[:id])   
    
    respond_to do |format|
      if @work_experience.update(position_params)
        @profile = current_user.profile
        @work_experiences = current_user.profile.work_experiencess
      else 
        render_errors(@work_experience)
      end
      format.js
    end  
  end

  def destroy
    @work_experience = WorkExperience.find(params[:id])
    @work_experience.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location)
  end

  def render_errors(experience)
    @errors = []
    experience.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

end