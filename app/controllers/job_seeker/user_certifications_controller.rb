class JobSeeker::UserCertificationsController < JobSeekersController
  def new
    @user_certification = UserCertification.new
  end

  def create
    @user_certification = UserCertification.new(certification_params.merge!(certification_id: params[:certification_id] ))
    @certifications = current_user.user_certifications


    if @user_certification.save
      respond_to do |format| 
        format.js
      end
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to job_seeker_profiles_path
    end
  end

  def edit
    @certifications = current_user.user_certifications
    @user_certification = UserCertification.find(params[:id])
  end

  def update
    @certifications = current_user.work_experiences
    @user_certification = UserCertification.find(params[:id])   
    
    respond_to do |format| 
      if @user_certification.update(certification_params)
        format.html { 
          if @user_certification.update(certification_params)
            flash[:success] = "#{@user_certification.certification.name} has been updated"
          else 
            flash[:danger] = "Something went wrong"
          end
          redirect_to job_seeker_profiles_path
        }
        format.js 
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
    params.require(:user_certification).permit(:user_id, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires)
  end

end