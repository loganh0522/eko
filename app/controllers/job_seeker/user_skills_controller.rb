class JobSeeker::UserSkillsController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new
    @user_skill = UserSkill.new
  end

  def create
    @user_skill = UserSkill.new(skill_id: params[:skills_id], user_id: current_user.id)
    @skills = current_user.user_skills

    if @user_skill.save
      respond_to do |format| 
        format.js
      end
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to job_seeker_profiles_path
    end
  end

  def destroy
    @user_skill = UserSkill.find(params[:id])
    @user_skill.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private

  def skill_params
    params.require(:user_skill).permit(:user_id)
  end

end