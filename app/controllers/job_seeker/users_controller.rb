class JobSeeker::UsersController < JobSeekersController 
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to job_seeker_profiles_path
    else
      redirect_to job_seeker_profiles_path
    end
  end

  def add_skills

  end

  def update_skills
    @user = User.find(current_user.id)
    @user_skills = UserSkill.create(user_id: @user.id, skill_id: params[:skills_id])
    
    if @user_skills.save
      redirect_to job_seeker_profiles_path
    else
      redirect_to job_seeker_profiles_path
    end
  end

  def delete_skill
    @skill = UserSkill.where(user_id: current_user.id, skill_id: params[:user_id])
    @skill.first.destroy   
    redirect_to job_seeker_profiles_path
  end

  def add_certifications

  end


  def update_certifications
    @user = User.find(current_user.id)
    @user_certification = UserCertification.create(user_id: @user.id, certification_id: params[:certification_id])
    
    if @user_certification.save
      redirect_to job_seeker_profiles_path
    else
      redirect_to job_seeker_profiles_path
    end
  end

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :tag_line, :country_ids, :state_ids, :city)
  end

  def user_skills_params
    params.require(:user).permit(:skill_ids, :user_ids)
  end
end