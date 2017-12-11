class JobSeeker::WorkExperiencesController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  before_filter :belongs_to_job_seeker, only: [:edit, :update, :destroy]
  # before_filter :profile_sign_up_complete
  
  def index
    @work_experiences = current_user.work_experiences.sort_by{|work| [work.start_year, work.end_year] }.reverse

    respond_to do |format|
      format.js
    end
  end

  def new
    @work_experience = WorkExperience.new

    respond_to do |format|
      format.js
    end
  end
  
  def create 
    @work_experience = WorkExperience.new(position_params.merge!(user_id: current_user.id))
   
    respond_to do |format|
      if @work_experience.save
        add_skills(@work_experience)
        @work_experiences = current_user.work_experiences.sort_by{|work| [work.start_year, work.end_year] }.reverse
      else 
        render_errors(@work_experience) 
      end
      format.js
    end  
  end

  def edit 
    @work_experience = WorkExperience.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @work_experience = WorkExperience.find(params[:id])   
    
    respond_to do |format|
      if @work_experience.update(position_params)
        add_skills(@work_experience)
        @work_experiences = current_user.work_experiences
      else 
        render_errors(@work_experience)
      end
      format.js
    end  
  end

  def destroy
    @work_experience = WorkExperience.find(params[:id])
    @work_experience.destroy

    respond_to do |format|
      format.js
    end
  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:user_id, :title, :company_name, :description, 
      :start_month, :start_year, :end_month, :end_year, :current_position, 
      :industry, :function, :location)
  end

  def add_skills(project)  
    if params[:user_skills].present?
      @skills = params[:user_skills].split(',')
      @project_skills = @project.user_skills

      @skills.each do |skill| 
        @skill = Skill.find_or_create_skill(skill)

        if !@project_skills.include?(UserSkill.where(skill_id: @skill.id, project_id: @project.id).first)
          UserSkill.create(user_id: current_user.id, skill_id: @skill.id, project_id: @project.id)
        end
      end
    end
  end

  def render_errors(experience)
    @errors = []
    experience.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end