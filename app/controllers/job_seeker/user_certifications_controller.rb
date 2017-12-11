class JobSeeker::UserCertificationsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  
  def index
    @certifications = current_user.user_certifications
    
    respond_to do |format|
      format.js
    end
  end

  def new
    @certification = UserCertification.new
    
    respond_to do |format|
      format.js
    end
  end

  def create
    @certification = UserCertification.new(certification_params.merge!(user_id: current_user.id))
    
    respond_to do |format|
      if @certification.save
        @certifications = current_user.user_certifications
        format.js
      else
        render_errors(@certification)
        format.js
      end
    end
  end

  def edit
    @certification = UserCertification.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @certification = UserCertification.find(params[:id])   
    
    respond_to do |format|
      if @certification.update(certification_params)
        format.js
      else
        render_errors(@certification)
        format.js
      end
    end
  end

  def destroy
    @certification = UserCertification.find(params[:id]) 
    @certification.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private

  def certification_params
    params.require(:user_certification).permit(:name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires)
  end

  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end