class JobSeeker::EducationsController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def index 
    @education = Education.new
    @user_degrees = current_user.profile.educations
  end

  def new
    @profile = current_user.profile
    @education = Education.new
  end

  def create 
    @education = Education.new(education_params.merge!(profile: current_user.profile))
    @degrees = current_user.profile.educations
    @profile = current_user.profile
    
    respond_to do |format|
      @errorSchool = [] 
      @errorDegree = [] 
      @errorStartYear = []
      @errorStartMonth = []
      @errorEndMonth = []
      @errorEndYear = [] 
      if @education.save
        format.js 
      else 
        format.js
        @degrees = current_user.profile.educations
        @profile = current_user.profile
        @education.errors.any?
        validate_education(@education)
      end
    end
  end

  def edit 
    @profile = current_user.profile
    @education = Education.find(params[:id])
  end

  def update 
    @profile = current_user.profile
    @education = Education.find(params[:id])
    respond_to do |format|
      @errorSchool = [] 
      @errorDegree = [] 
      @errorStartYear = []
      @errorStartMonth = []
      @errorEndMonth = []
      @errorEndYear = [] 
      if @education.update(education_params)
        format.js
      else
        format.js
        @degrees = current_user.profile.educations
        @profile = current_user.profile
        @education.errors.any?
        validate_education(@education)
      end
    end
  end

  def destroy
    @education = Education.find(params[:id])
    @education.destroy
    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private 

  def education_params
    params.require(:education).permit(:school, :degree, :description, :start_month, :start_year, :end_month, :end_year)
  end

  def validate_education(education)
    if (education.errors["school"] != nil)
      @errorSchool.push(education.errors["school"][0])
    end  
    if (education.errors["degree"] != nil)
      @errorDegree.push(education.errors["degree"][0])
    end
    if (education.errors["start_year"] != nil)
      @errorStartYear.push(education.errors["start_year"][0])
    end
    if (education.errors["start_month"] != nil)
      @errorStartMonth.push(education.errors["start_month"][0])
    end
    if (education.errors["end_year"] != nil)
      @errorEndYear.push(education.errors["end_year"][0])
    end
    if (education.errors["end_month"] != nil)
      @errorEndMonth.push(education.errors["end_month"][0])
    end
  end
end