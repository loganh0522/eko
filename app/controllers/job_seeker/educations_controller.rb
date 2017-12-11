class JobSeeker::EducationsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  
  def index 
    @educations = current_user.educations

    respond_to do |format| 
      format.js
    end
  end

  def new
    @education = Education.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @education = Education.new(education_params.merge!(user_id: current_user.id))
    
    respond_to do |format|
      if @education.save
        @educations = current_user.educations
      else 
        render_errors(@education)
      end
      format.js
    end
  end

  def edit 
    @education = Education.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end

  def update 
    @education = Education.find(params[:id])
    
    respond_to do |format|
      if @education.update(education_params)
        @educations = current_user.educations
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
    params.require(:education).permit(:school, :degree, :description, 
      :start_month, :start_year, :end_month, :end_year)
  end

  def render_errors(education)
    @errors = []
    education.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end