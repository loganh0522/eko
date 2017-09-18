class JobSeeker::UserSkillsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new
    @user_skill = UserSkill.new
    @work_experience = WorkExperience.find(params[:work_experience_id])
    @profile = current_user.profile

    respond_to do |format| 
      format.js
    end
  end

  def create
    @skill = Skill.find_or_create_skill(params[:name])
    @work_experience = WorkExperience.find(params[:work_experience_id])
    @user_skill = UserSkill.new(skill_id: @skill.id, work_experience_id: params[:work_experience_id])
    @skills = @work_experience.skills
    @profile = current_user.profile
    
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
    # @user_skill = UserSkill.where(skill_id: params[:id], work_experience_id: params[:work_experience_id]).first
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