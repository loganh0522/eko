class JobSeeker::UserSkillsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  
  def new
    @user_skill = UserSkill.new
    @work_experience = WorkExperience.find(params[:work_experience_id])

    respond_to do |format| 
      format.js
    end
  end

  def create
    @skill = Skill.find_or_create_skill(params[:name])
    @work_experience = WorkExperience.find(params[:work_experience_id])
    @user_skill = UserSkill.new(skill_id: @skill.id, work_experience_id: params[:work_experience_id], 
      user_id: current_user.id)
   
    respond_to do |format| 
      if @user_skill.save
        format.js
      else
        render_errors(@user_skill)
        format.js
      end
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

  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def skill_params
    params.require(:user_skill).permit(:user_id, :work_experience_id)
  end
end