class JobSeeker::WorkExperiencesController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new
    @profile = current_user.profile
    @work_experience = WorkExperience.new

    respond_to do |format|
      format.js
    end
  end
  
  def create 
    @profile = current_user.profile
    @positions = current_user.profile.work_experiences
    @work_experience = WorkExperience.new(position_params.merge!(profile: current_user.profile))
   
    respond_to do |format|
      @errorTitle = [] 
      @errorCompany = [] 
      @errorStartYear = []
      @errorStartMonth = []
      @errorDescription = []
      @errorIndustry =[]
      @errorFunction = []
      @errorEndMonth = []
      @errorEndYear = [] 

      if @work_experience.save
        format.js 
        @profile = current_user.profile
        @work_experiences = current_user.profile.work_experiences.sort_by{|work| [work.start_year, work.end_year] }.reverse
      else 
        format.js
        @profile = current_user.profile
        @work_experiences = current_user.profile.work_experiences

        @work_experience.errors.any?
        if (@work_experience.errors["title"] != nil)
          @errorTitle.push(@work_experience.errors["title"][0])
        end
        
        if (@work_experience.errors["company_name"] != nil)
          @errorCompany.push(@work_experience.errors["company_name"][0])
        end

        if (@work_experience.errors["start_year"] != nil)
          @errorStartYear.push(@work_experience.errors["start_year"][0])
        end

        if (@work_experience.errors["start_month"] != nil)
          @errorStartMonth.push(@work_experience.errors["start_month"][0])
        end

        if (@work_experience.errors["end_year"] != nil)
          @errorEndYear.push(@work_experience.errors["end_year"][0])
        end

        if (@work_experience.errors["end_month"] != nil)
          @errorEndMonth.push(@work_experience.errors["end_month"][0])
        end

        if (@work_experience.errors["industry_ids"] != nil)
          @errorIndustry.push(@work_experience.errors["industry_ids"][0])
        end

        if (@work_experience.errors["function_ids"] != nil)
          @errorFunction.push(@work_experience.errors["function_ids"][0])
        end
        if (@work_experience.errors["description"] != nil)
          @errorDescription.push(@work_experience.errors["description"][0])
        end
      end
    end  
  end

  def edit 
    @profile = current_user.profile
    @positions = current_user.profile.work_experiences
    @work_experience = WorkExperience.find(params[:id])
  end

  def update
    @profile = current_user.profile
    @positions = current_user.profile.work_experiences
    @work_experience = WorkExperience.find(params[:id])   
    
    respond_to do |format|
      @errorTitle = [] 
      @errorCompany = [] 
      @errorStartYear = []
      @errorStartMonth = []
      @errorDescription = []
      @errorIndustry =[]
      @errorFunction = []
      @errorEndMonth = []
      @errorEndYear = [] 

      if @work_experience.update(position_params)
        format.js 
      else 
        format.js
        @profile = current_user.profile
        @work_experiences = current_user.profile.work_experiences

        @work_experience.errors.any?
        
        if (@work_experience.errors["title"] != nil)
          @errorTitle.push(@work_experience.errors["title"][0])
        end
        
        if (@work_experience.errors["company_name"] != nil)
          @errorCompany.push(@work_experience.errors["company_name"][0])
        end

        if (@work_experience.errors["start_year"] != nil)
          @errorStartYear.push(@work_experience.errors["start_year"][0])
        end

        if (@work_experience.errors["start_month"] != nil)
          @errorStartMonth.push(@work_experience.errors["start_month"][0])
        end

        if (@work_experience.errors["end_year"] != nil)
          @errorEndYear.push(@work_experience.errors["end_year"][0])
        end

        if (@work_experience.errors["end_month"] != nil)
          @errorEndMonth.push(@work_experience.errors["end_month"][0])
        end

        if (@work_experience.errors["industry_ids"] != nil)
          @errorIndustry.push(@work_experience.errors["industry_ids"][0])
        end

        if (@work_experience.errors["function_ids"] != nil)
          @errorFunction.push(@work_experience.errors["function_ids"][0])
        end
        if (@work_experience.errors["description"] != nil)
          @errorDescription.push(@work_experience.errors["description"][0])
        end
      end
    end  
  end

  def destroy
    @work_experience = WorkExperience.find(params[:id])
    @work_experience.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location)
  end

  def handle_errors(work_experience)
    if (work_experience.errors["title"] != nil)
      @errorTitle.push(@message.errors["title"][0])
    elsif (@work_experience.errors["company_name"] != nil)
      @errorCompany.push(@message.errors["company_name"][0])
    elsif (@work_experience.errors["start_year"] != nil)
      @errorStartYear.push(@message.errors["start_year"][0])
    elsif (@work_experience.errors["start_month"] != nil)
      @errorStartMonth.push(@message.errors["start_month"][0])
    elsif (@work_experience.errors["end_year"] != nil)
      @errorEndYear.push(@message.errors["end_year"][0])
    elsif (@work_experience.errors["end_month"] != nil)
      @errorMonth.push(@message.errors["end_month"][0])
    elsif (work_experience.errors["industry_ids"] != nil)
      @errorIndustry.push(@message.errors["industry_ids"][0])
    elsif (@work_experience.errors["function_ids"] != nil)
      @errorFunction.push(@message.errors["function_ids"][0])
    elsif (@work_experience.errors["description"] != nil)
      @errorDescription.push(@message.errors["description"][0])
    end
  end
end