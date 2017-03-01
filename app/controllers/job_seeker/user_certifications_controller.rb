class JobSeeker::UserCertificationsController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new
    @profile = current_user.profile 
    @user_certification = UserCertification.new
  end

  def create
    @profile = current_user.profile 
    @user_certification = UserCertification.new(certification_params.merge!(profile: current_user.profile))
    respond_to do |format|
      @errorName = [] 
      @errorAgency = [] 
      @errorStartYear = []
      @errorStartMonth = []
      @errorEndMonth = []
      @errorEndYear = [] 
      if @user_certification.save
        format.js
      else
        format.js
        @certifications = current_user.profile.user_certifications
        @profile = current_user.profile
        @user_certification.errors.any?
        validate_certification(@user_certification)
      end
    end
  end

  def edit
    @profile = current_user.profile
    @user_certification = UserCertification.find(params[:id])
  end

  def update
    @profile = current_user.profile 
    @certifications = current_user.profile.user_certifications
    @user_certification = UserCertification.find(params[:id])   
    respond_to do |format|
      @errorName = [] 
      @errorAgency = [] 
      @errorStartYear = []
      @errorStartMonth = []
      @errorEndMonth = []
      @errorEndYear = [] 

      if @user_certification.update(certification_params)
        format.js
      else
        format.js
        @certifications = current_user.profile.user_certifications
        @profile = current_user.profile
        @user_certification.errors.any?
        validate_certification(@user_certification)
      end
    end
  end

  def destroy
    @user_certification = UserCertification.find(params[:id]) 
    @user_certification.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private

  def certification_params
    params.require(:user_certification).permit(:name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires)
  end

  def validate_certification(certification)
    if (certification.errors["name"] != nil)
      @errorName.push(certification.errors["name"][0])
    end  
    if (certification.errors["agency"] != nil)
      @errorAgency.push(certification.errors["agency"][0])
    end
    if (certification.errors["start_year"] != nil)
      @errorStartYear.push(certification.errors["start_year"][0])
    end
    if (certification.errors["start_month"] != nil)
      @errorStartMonth.push(certification.errors["start_month"][0])
    end
    if (certification.errors["end_year"] != nil)
      @errorEndYear.push(certification.errors["end_year"][0])
    end
    if (certification.errors["end_month"] != nil)
      @errorEndMonth.push(certification.errors["end_month"][0])
    end
  end

end