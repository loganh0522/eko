class JobSeeker::EducationsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  
  def index 
    @education = Education.new
    @user_degrees = current_user.educations
  end

  def new
    @user = current_user
    @education = Education.new
  end

  def create 
    @education = Education.new(education_params.merge!(user_id: current_user.id))
    @degrees = current_user.educations
    @user = current_user
    
    respond_to do |format|
      if @education.save
        @degrees = current_user.educations
        @profile = current_user
      else 
        render_errors(@education)
      end
      format.js
    end
  end

  def edit 
    @profile = current_user
    @education = Education.find(params[:id])
  end

  def update 
    @user = current_user
    @education = Education.find(params[:id])
    
    respond_to do |format|
      if @education.update(education_params)
        @degrees = current_user.educations
        @user = current_user
      else
        render_errors(@education)
      end
      format.js
    end
  end

  def destroy
    @education = Education.find(params[:id])
    @education.destroy

    respond_to do |format|
      format.js
    end
  end

  private 

  def education_params
    params.require(:education).permit(:school, :degree, :description, :start_month, :start_year, :end_month, :end_year)
  end

  def render_errors(education)
    @errors = []
    education.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end